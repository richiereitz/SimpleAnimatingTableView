//
//  ATPresentationTransitionManager.m
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import "ATPresentationTransitionManager.h"
#import "ATPresentationAnimationManager.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@interface ATPresentationTransitionManager ()

#pragma mark - animationManaher
@property (nonatomic, strong, nullable) ATPresentationAnimationManager* animationManager;

@end





@implementation ATPresentationTransitionManager

#pragma mark - NSObject
-(instancetype)init
{
	if (self = [super init])
	{
		_animationManager = [ATPresentationAnimationManager new];
	}
	
	return self;
}

#pragma mark - UIViewControllerTransitioningDelegate
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
	[self.animationManager setIsPresentation:YES];
	return self.animationManager;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
	[self.animationManager setIsPresentation:NO];
	return self.animationManager;
}

#pragma mark - referenceFrame
-(void)setReferenceFrame:(CGRect)referenceFrame
{
	kRUConditionalReturn(CGRectEqualToRect(self.referenceFrame, referenceFrame), NO);
	
	_referenceFrame = referenceFrame;
	
	[self.animationManager setReferenceFrame:referenceFrame];
}

@end
