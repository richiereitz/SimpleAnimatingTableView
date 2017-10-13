//
//  ATAnimatingTableViewController.m
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import "ATAnimatingTableViewController.h"

#import <ResplendentUtilities/NSString+RUMacros.h>
#import <ResplendentUtilities/RUConditionalReturn.h>





@interface ATAnimatingTableViewController () <UITableViewDelegate, UITableViewDataSource>

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

#pragma mark - cellHeight
-(CGFloat)cellHeight_default;
-(CGFloat)cellHeight_expanded;

@end





@implementation ATAnimatingTableViewController

#pragma mark - UIViewController
-(void)viewDidLoad
{
	[super viewDidLoad];
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[self.tableView setBackgroundColor:[UIColor orangeColor]];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.view addSubview:self.tableView];
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	[self.tableView setFrame:[self tableView_frame]];
}

#pragma mark - tableView
-(CGRect)tableView_frame
{
	return self.view.bounds;
}

-(void)tableView_expandedIndexPath_animate_update
{
	CGPoint const currentOffset = self.tableView.contentOffset;
	CGFloat const heightDifference = [self cellHeight_expanded] - [self cellHeight_default];
	
	//if this height difference is negative something has gone wrong, so we assert that the expanded hight must be larger
	kRUConditionalReturn(heightDifference < 0, YES);
	
	//Since we want the animation to appear as though the cells are shifing an equal amount in both directions, we will use half of the difference in height for our offset
	CGFloat const heightModifier = heightDifference / 2.0f;
	
#warning !!WARNING!! come back and update this logic to be more performant. Want to handle offset in edge cases
	[self.tableView setContentOffset:(CGPoint){
		.x = 0,
		.y = (self.expandedIndexPath) ? currentOffset.y + heightModifier : currentOffset.y - heightModifier
	}];

}

#pragma mark - cellHeight
-(CGFloat)cellHeight_default
{
	return 150.0f;
}

-(CGFloat)cellHeight_expanded
{
	return 250.0f;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	kRUDefineNSStringConstant(kATAnimatingTableViewCell_StringIdentifier);
	UITableViewCell* const cell = ([self.tableView dequeueReusableCellWithIdentifier:kATAnimatingTableViewCell_StringIdentifier]
								   ?:
								   [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kATAnimatingTableViewCell_StringIdentifier]);
	[cell setBackgroundColor:[UIColor whiteColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
	
	_expandedIndexPath = expandedIndexPath;
	
	//Since animating the height expansion of these cells doesn't natively animate out in both directions as the design implies, we can simulate this efect by animating the content offset of the tableview itself
	__weak typeof(self) const self_weak = self;
	[UIView animateWithDuration:0.3 animations:^{
		[self tableView_expandedIndexPath_animate_update];
	}];
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

@end
