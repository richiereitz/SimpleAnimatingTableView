//
//  ATExpandingTableViewCell.m
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import "ATExpandingTableViewCell.h"

#import <ResplendentUtilities/UIView+RUUtility.h>





@interface ATExpandingTableViewCell()

#pragma mark - roundedContentView
-(CGRect)roundedContentView_frame;

#pragma mark - beginAnimatedPresentationButton
@property (nonatomic, readonly, strong, nullable) UIButton* beginAnimatedPresentationButton;
-(CGRect)beginAnimatedPresentationButton_frame;
-(void)beginAnimatedPresentationButton_didTouchUpInside;

@end





@implementation ATExpandingTableViewCell

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
		.width = 20.0f,
		.height = 10.0f
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

@end
