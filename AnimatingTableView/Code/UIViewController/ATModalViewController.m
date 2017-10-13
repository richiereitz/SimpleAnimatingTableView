//
//  ATModalViewController.m
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import "ATModalViewController.h"

#import <ResplendentUtilities/UIView+RUUtility.h>





@interface ATModalViewController ()

#pragma mark - dismissButton
@property (nonatomic, readonly, strong, nullable) UIButton* dismissButton;
-(CGRect)dismissButton_frame;
-(void)dismissButton_didTouchUpInside;

@end





@implementation ATModalViewController

#pragma mark - UIViewController
-(void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor redColor]];
	
	_dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.dismissButton setBackgroundColor:[UIColor blueColor]];
	[self.dismissButton setTitle:@"Push Me To Go Back" forState:UIControlStateNormal];
	[self.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.dismissButton addTarget:self action:@selector(dismissButton_didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.dismissButton];
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	[self.dismissButton setFrame:[self dismissButton_frame]];
}

#pragma mark - dismissButton
-(CGRect)dismissButton_frame
{
	CGSize const size = (CGSize){
		.width = 200.0f,
		.height = 100.0f,
	};
	
	return CGRectCeilOrigin((CGRect){
		.origin.x	= CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(size.width, CGRectGetWidth(self.view.bounds)),
		.origin.y	= 20.0f,
		.size		= size
	});
}

-(void)dismissButton_didTouchUpInside
{
	__weak typeof(self) const self_weak = self;
	[UIView animateWithDuration:0.3 animations:^{
		[self_weak.view setBackgroundColor:[UIColor whiteColor]];
	}];
	
	[self.dismissButtonDelegate modalViewController_dismissButton_didTouchUpInside];
}

@end
