//
//  ATAnimatingTableViewController.m
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import "ATAnimatingTableViewController.h"
#import "ATExpandingTableViewCell.h"
#import "ATPresentationTransitionManager.h"
#import "ATModalViewController.h"
#import "ATCellHelper.h"

#import <ResplendentUtilities/NSString+RUMacros.h>
#import <ResplendentUtilities/RUConditionalReturn.h>





@interface ATAnimatingTableViewController () <UITableViewDelegate, UITableViewDataSource, ATExpandingTableViewCell_beginAnimatedPresentationButton_didTouchUpInsideDelegate, ATModalViewController_dismissalDelegate>

#pragma mark - tableView
@property (nonatomic, readonly, strong, nullable) UITableView* tableView;
-(CGRect)tableView_frame;
-(void)tableView_expandedIndexPath_animate_update;

#pragma mark - expandedIndexPath_previous
@property (nonatomic, strong, nullable) NSIndexPath* expandedIndexPath_previous;

#pragma mark - expandedIndexPath
@property (nonatomic, strong, nullable) NSIndexPath* expandedIndexPath;
-(void)expandedIndexPath_update_for_selectedIndexPath:(nonnull NSIndexPath*)selectedIndexPath;
-(nullable NSIndexPath*)expandedIndexPath_appropriate_for_selectedIndexPath:(nonnull NSIndexPath*)selectedIndexPath;

#pragma mark - expandedIndexPath_shouldExpandFooter
@property (nonatomic, assign) BOOL expandedIndexPath_shouldExpandFooter;

#pragma mark - cellHeight
-(CGFloat)cellHeight_default;
-(CGFloat)cellHeight_expanded;

#pragma mark - transitionManager
@property (nonatomic, strong, nullable) ATPresentationTransitionManager* transitionManager;

#pragma mark - referenceRect
@property (nonatomic, assign) CGRect refrenceRect;

#pragma mark - beginTransition
-(void)beginTransition;

#pragma mark - cellHelpers
@property (nonatomic, readonly, strong, nullable) NSArray<ATCellHelper*>* cellHelpers;

@end





@implementation ATAnimatingTableViewController

@synthesize cellHelpers = _cellHelpers;
-(NSArray<ATCellHelper *> *)cellHelpers
{
	if (_cellHelpers == nil)
	{
		NSMutableArray<ATCellHelper*>* cellHelpers_mutable = [NSMutableArray<ATCellHelper*> array];
		for (NSInteger x = 0 ; x < 50 ; x++)
		{
			ATCellHelper* helper = [ATCellHelper new];
			[cellHelpers_mutable addObject:helper];
		}
		
		_cellHelpers = [NSArray<ATCellHelper*> arrayWithArray:cellHelpers_mutable];
	}
	
	return _cellHelpers;
}

#pragma mark - UIViewController
-(void)viewDidLoad
{
	[super viewDidLoad];
	
	_transitionManager = [ATPresentationTransitionManager new];
	
	[self.navigationItem setTitle:@"Tap a cell to start"];
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[self.tableView setBackgroundColor:[UIColor blueColor]];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.view addSubview:self.tableView];

	/* The following modifications to UITableView are done to disable certain automations that UITableView forces in iOS 11. This is to maintain consistent functionality with older iOS versions */
	[self.tableView setEstimatedSectionFooterHeight:0.0f];
	[self.tableView setEstimatedSectionHeaderHeight:0.0f];
	[self.tableView setEstimatedRowHeight:0.0f];
	if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)])
	{
		if (@available(iOS 11, *))
		{
			[self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
		}
		else
		{
			NSAssert(false, @"should be available.");
		}
	}
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	[self.tableView setFrame:[self tableView_frame]];
}

#pragma mark - tableView
-(CGRect)tableView_frame
{
	return UIEdgeInsetsInsetRect(self.view.bounds, (UIEdgeInsets){
		.top = CGRectGetMaxY(self.navigationController.navigationBar.frame)
	});
}

-(void)tableView_expandedIndexPath_animate_update
{
	kRUConditionalReturn(self.expandedIndexPath.section == 0 && self.expandedIndexPath, NO);
	kRUConditionalReturn(self.expandedIndexPath.section == [self.tableView numberOfSections] - 1, NO);
	
	CGPoint const currentOffset = self.tableView.contentOffset;
	CGFloat const heightDifference = [self cellHeight_expanded] - [self cellHeight_default];
	
	//if this height difference is negative something has gone wrong, so we assert that the expanded hight must be larger
	kRUConditionalReturn(heightDifference < 0, YES);
	
	//Since we want the animation to appear as though the cells are shifing an equal amount in both directions, we will use half of the difference in height for our offset
	CGFloat const heightModifier = heightDifference / 2.0f;
	
	[self.tableView setContentOffset:(CGPoint){
		.x = 0,
		.y = (self.expandedIndexPath) ? currentOffset.y + heightModifier : currentOffset.y - heightModifier
	}];

}

-(void)tableView_expandedIndexPath_shouldExpandFooter_animate_update
{
	CGPoint const currentOffset = self.tableView.contentOffset;
	CGFloat const heightDifference = [self cellHeight_expanded] - [self cellHeight_default];
	
	//if this height difference is negative something has gone wrong, so we assert that the expanded hight must be larger
	kRUConditionalReturn(heightDifference < 0, YES);
	
	//Since we want the animation to appear as though the cells are shifing an equal amount in both directions, we will use half of the difference in height for our offset
	CGFloat const heightModifier = heightDifference / 2.0f;
	
	
	[self.tableView setContentOffset:(CGPoint){
		.x = 0,
		.y = (self.expandedIndexPath_shouldExpandFooter) ? currentOffset.y + heightModifier : currentOffset.y - heightModifier
	}];
	
	[self setRefrenceRect:CGRectOffset(self.refrenceRect, 0.0f, (self.expandedIndexPath_shouldExpandFooter) ? - heightModifier : heightModifier)];
	
}

#pragma mark - cellHeight
-(CGFloat)cellHeight_default
{
	return 100.0f;
}

-(CGFloat)cellHeight_expanded
{
	return 200.0f;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.cellHelpers.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	kRUDefineNSStringConstant(kATExpandingTableViewCell_StringIdentifier);
	ATExpandingTableViewCell* const cell = ([self.tableView dequeueReusableCellWithIdentifier:kATExpandingTableViewCell_StringIdentifier]
								   ?:
								   [[ATExpandingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kATExpandingTableViewCell_StringIdentifier]);

	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[cell setBeginAnimatedPresentationButtonDelegate:self];
	
	ATCellHelper* const cellHelper = self.cellHelpers[indexPath.section];
	[cell setCellHelper:cellHelper];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView beginUpdates];
	[self expandedIndexPath_update_for_selectedIndexPath:indexPath];
	[self.tableView endUpdates];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	kRUConditionalReturn_ReturnValue(self.expandedIndexPath == indexPath, NO, [self cellHeight_expanded])
	return [self cellHeight_default];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	kRUConditionalReturn_ReturnValue(self.expandedIndexPath_shouldExpandFooter == true && section == self.expandedIndexPath.section, NO, 100.0f);
	
	return 25.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UIView* const footerView = [UIView new];
	[footerView setBackgroundColor:[UIColor clearColor]];
	return footerView;
}

#pragma mark - expandedIndexPath
-(void)setExpandedIndexPath:(nullable NSIndexPath*)expandedIndexPath
{
	kRUConditionalReturn(self.expandedIndexPath == expandedIndexPath, NO);
	
	[self setExpandedIndexPath_previous:self.expandedIndexPath];
	if (self.expandedIndexPath)
	{
		ATCellHelper* const cellHelper = self.cellHelpers[self.expandedIndexPath.section];
		[cellHelper setCellShouldShowButton:NO];
	}
	
	_expandedIndexPath = expandedIndexPath;
	
	//Since animating the height expansion of these cells doesn't natively animate out in both directions as the design implies, we can simulate this efect by animating the content offset of the tableview itself
	__weak typeof(self) const self_weak = self;
	[UIView animateWithDuration:0.3 animations:^{
		[self_weak tableView_expandedIndexPath_animate_update];
	}];
	
	if (self.expandedIndexPath)
	{
		ATCellHelper* const cellHelper = self.cellHelpers[self.expandedIndexPath.section];
		[cellHelper setCellShouldShowButton:YES];
	}
}

-(void)expandedIndexPath_update_for_selectedIndexPath:(nonnull NSIndexPath*)selectedIndexPath
{
	[self setExpandedIndexPath:[self expandedIndexPath_appropriate_for_selectedIndexPath:selectedIndexPath]];
}

-(nullable NSIndexPath*)expandedIndexPath_appropriate_for_selectedIndexPath:(nonnull NSIndexPath*)selectedIndexPath
{
	kRUConditionalReturn_ReturnValueNil(self.expandedIndexPath != nil, NO);
	
	return selectedIndexPath;
}

#pragma mark - expandedIndexPath_shouldExpandFooter
-(void)setExpandedIndexPath_shouldExpandFooter:(BOOL)expandedIndexPath_shouldExpandFooter
{
	kRUConditionalReturn(self.expandedIndexPath_shouldExpandFooter == expandedIndexPath_shouldExpandFooter, NO);
	
	_expandedIndexPath_shouldExpandFooter = expandedIndexPath_shouldExpandFooter;
	
	if (expandedIndexPath_shouldExpandFooter)
	{
		__weak typeof(self) const self_weak = self;
		[UIView animateWithDuration:0.3
						 animations:^
		 {
			 [self_weak tableView_expandedIndexPath_shouldExpandFooter_animate_update];
		 }
						 completion:^(BOOL finished)
		 {
			 [self_weak beginTransition];
		 }];
	}
	else
	{
		__weak typeof(self) const self_weak = self;
		[UIView animateWithDuration:0.3
						 animations:^
		 {
			 [self_weak tableView_expandedIndexPath_shouldExpandFooter_animate_update];
			 [self_weak beginTransition];

		 }
						 completion:nil];
	}

}

#pragma mark - beginTransition
-(void)beginTransition
{
	kRUConditionalReturn(CGRectEqualToRect(self.refrenceRect, CGRectZero), YES);
	
	[self.transitionManager setReferenceFrame:self.refrenceRect];

	if (self.presentedViewController)
	{
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	else
	{
		ATModalViewController* const modal = [ATModalViewController new];
		[modal setModalPresentationStyle:UIModalPresentationCustom];
		[modal setTransitioningDelegate:self.transitionManager];
		[modal setDismissButtonDelegate:self];
		
		[self presentViewController:modal animated:YES completion:nil];
	}
}

#pragma mark - ATExpandingTableViewCell_beginAnimatedPresentationButton_didTouchUpInsideDelegate
-(void)expandingTableViewCell_beginAnimatedPresentationButton_didTouchUpInside:(ATExpandingTableViewCell *)expandingTableViewCell
															 withReferenceRect:(CGRect)referenceRect
{
	[self setRefrenceRect:[expandingTableViewCell convertRect:expandingTableViewCell.roundedContentView.frame toView:self.view]];
	[self.tableView beginUpdates];
	[self setExpandedIndexPath_shouldExpandFooter:YES];
	[self.tableView endUpdates];
	
	ATCellHelper* const cellHelper = self.cellHelpers[self.expandedIndexPath.section];
	[cellHelper setCellShouldShowButton:NO];
}

#pragma mark - ATModalViewController_dismissalDelegate
-(void)modalViewController_dismissButton_didTouchUpInside
{
	[self.tableView beginUpdates];
	[self setExpandedIndexPath_shouldExpandFooter:NO];
	[self.tableView endUpdates];
	
	ATCellHelper* const cellHelper = self.cellHelpers[self.expandedIndexPath.section];
	[cellHelper setCellShouldShowButton:YES];
}

@end
