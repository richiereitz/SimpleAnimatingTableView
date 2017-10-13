//
//  ATExpandingTableViewCell.m
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import "ATExpandingTableViewCell.h"
#import "ATCellHelper.h"

#import <ResplendentUtilities/UIView+RUUtility.h>
#import <ResplendentUtilities/RUConditionalReturn.h>





static void* kATExpandingTableViewCell_KVOContext = &kATExpandingTableViewCell_KVOContext;





@interface ATExpandingTableViewCell ()

#pragma mark - roundedContentView
-(CGRect)roundedContentView_frame;

#pragma mark - beginAnimatedPresentationButton
@property (nonatomic, readonly, strong, nullable) UIButton* beginAnimatedPresentationButton;
-(CGRect)beginAnimatedPresentationButton_frame;
-(void)beginAnimatedPresentationButton_didTouchUpInside;

#pragma mark - cellHelper
-(void)cellHelper_setKVORegistered:(BOOL)registered;

@end





@implementation ATExpandingTableViewCell

#pragma mark - dealloc
-(void)dealloc
{
	[self cellHelper_setKVORegistered:NO];
}

#pragma mark - UITableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		[self setBackgroundColor:[UIColor clearColor]];
		[self.contentView setBackgroundColor:[UIColor clearColor]];
		
		_roundedContentView = [UIView new];
		[self.roundedContentView setBackgroundColor:[UIColor whiteColor]];
		[self.roundedContentView.layer setCornerRadius:8.0f];
		[self.contentView addSubview:self.roundedContentView];
		
		_beginAnimatedPresentationButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.beginAnimatedPresentationButton addTarget:self action:@selector(beginAnimatedPresentationButton_didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.beginAnimatedPresentationButton setBackgroundColor:[UIColor purpleColor]];
		[self.beginAnimatedPresentationButton setAlpha:0.0f];
		[self.roundedContentView addSubview:self.beginAnimatedPresentationButton];
	}
	
	return self;
}

#pragma mark - UIView
-(void)layoutSubviews
{
	[super layoutSubviews];
	
	[self.roundedContentView setFrame:[self roundedContentView_frame]];
	[self.beginAnimatedPresentationButton setFrame:[self beginAnimatedPresentationButton_frame]];
	[self.beginAnimatedPresentationButton.layer setCornerRadius:CGRectGetHeight([self beginAnimatedPresentationButton_frame]) / 2.0f];
}

#pragma mark - roundedContentView
-(CGRect)roundedContentView_frame
{
	CGFloat const padding_horizontal = 30.0f;
	return UIEdgeInsetsInsetRect(self.contentView.bounds, (UIEdgeInsets){
		.left = padding_horizontal,
		.right = padding_horizontal
	});
}

#pragma mark - beginAnimatedPresentationButton
-(CGRect)beginAnimatedPresentationButton_frame
{
	CGSize const buttonSize = (CGSize){
		.width = 40.0f,
		.height = 20.0f
	};
	
	CGFloat const padding = 10.0f;
	
	return (CGRect){
		.origin.y = CGRectGetHeight([self roundedContentView_frame]) - buttonSize.height - padding,
		.origin.x = CGRectGetWidth([self roundedContentView_frame]) - buttonSize.width - padding,
		.size = buttonSize
	};
}

-(void)beginAnimatedPresentationButton_didTouchUpInside
{
	[self.beginAnimatedPresentationButtonDelegate expandingTableViewCell_beginAnimatedPresentationButton_didTouchUpInside:self
																										withReferenceRect:[self roundedContentView_frame]];
}

#pragma mark - cellHelper
-(void)setCellHelper:(ATCellHelper *)cellHelper
{
	kRUConditionalReturn(self.cellHelper == cellHelper, NO);
	
	[self cellHelper_setKVORegistered:NO];
	
	_cellHelper = cellHelper;
	
	[self cellHelper_setKVORegistered:YES];
}

-(void)cellHelper_setKVORegistered:(BOOL)registered
{
	typeof(self.cellHelper) const cellHelper = self.cellHelper;
	kRUConditionalReturn(cellHelper == nil, NO);
	
	NSMutableArray<NSString*>* const propertiesToObserve = [NSMutableArray<NSString*> array];
	[propertiesToObserve addObject:[ATCellHelper_PropertiesForKVO cellShouldShowButton]];
	
	[propertiesToObserve enumerateObjectsUsingBlock:^(NSString* _Nonnull propertyToObserve, NSUInteger idx, BOOL * _Nonnull stop) {
		
		if (registered)
		{
			[cellHelper addObserver:self
					   forKeyPath:propertyToObserve
						  options:(NSKeyValueObservingOptionInitial)
						  context:&kATExpandingTableViewCell_KVOContext];
		}
		else
		{
			[cellHelper removeObserver:self
						  forKeyPath:propertyToObserve
							 context:&kATExpandingTableViewCell_KVOContext];
		}
	}];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(nullable NSString*)keyPath ofObject:(nullable id)object change:(nullable NSDictionary*)change context:(nullable void*)context
{
	if (context == kATExpandingTableViewCell_KVOContext)
	{
		if (object == self.cellHelper)
		{
			if ([keyPath isEqualToString:[ATCellHelper_PropertiesForKVO cellShouldShowButton]])
			{
				__weak typeof(self) const self_weak = self;
				[UIView animateWithDuration:0.3 animations:^{
					[self_weak.beginAnimatedPresentationButton setAlpha:(self.cellHelper.cellShouldShowButton) ? 1.0f:0.0f];
				}];
			}
			else
			{
				NSAssert(false, @"unhandled keyPath %@",keyPath);
			}
		}
		else
		{
			NSAssert(false, @"unhandled object %@",object);
		}
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end
