//
//  ATModalViewController.m
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import "ATModalViewController.h"





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
	
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	_dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.dismissButton setBackgroundColor:[UIColor redColor]];
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
	return (CGRect){
		.origin.x = 50,
		.origin.y = 50,
		.size.width = 50,
		.size.height = 50
	};
}

-(void)dismissButton_didTouchUpInside
{
	[self.dismissButtonDelegate modalViewController_dismissButton_didTouchUpInside];
}

@end
