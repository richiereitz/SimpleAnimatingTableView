//
//  ATPresentationAnimationManager.m
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import "ATPresentationAnimationManager.h"

#import <ResplendentUtilities/RUConditionalReturn.h>
#import <ResplendentUtilities/RUClassOrNilUtil.h>





@interface ATPresentationAnimationManager () <CAAnimationDelegate>

#pragma mark - transitionContext
@property (nonatomic, assign, nullable) id<UIViewControllerContextTransitioning> transitionContext;

#pragma mark - animatePresentation
-(void)animatePresentation;

#pragma mark - animateDismissal
-(void)animateDismissal;

#pragma mark - isPresentation
-(void)isPresentation_handleTransition;

#pragma mark - fromViewController
-(nullable UIViewController*)fromViewController;

#pragma mark - toViewController
-(nullable UIViewController*)toViewController;

#pragma mark - referenceFrame
-(nullable UIBezierPath*)referenceFrame_rounded_bezierPath;

#pragma mark - fullscreenFrame_rounded_bezierPath
-(nullable UIBezierPath*)fullscreenFrame_rounded_bezierPath;

@end





@implementation ATPresentationAnimationManager

#pragma mark - UIViewControllerAnimatedTransitioning
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
	return 0.4f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	[self setTransitionContext:transitionContext];
	[self isPresentation_handleTransition];
}

-(void)isPresentation_handleTransition
{
	if (self.isPresentation)
	{
		[self animatePresentation];
	}
	else
	{
		[self animateDismissal];
	}
}

#pragma mark - referenceFrame
-(nullable UIBezierPath*)referenceFrame_rounded_bezierPath
{
	CGFloat const cornerRadius = 13.0f;
	return [UIBezierPath
			bezierPathWithRoundedRect:self.referenceFrame
			byRoundingCorners:UIRectCornerAllCorners
			cornerRadii:(CGSize){
				.height = cornerRadius,
				.width = cornerRadius,
			}];
}

#pragma mark - fullscreenFrame_rounded_bezierPath
-(nullable UIBezierPath*)fullscreenFrame_rounded_bezierPath
{
	id <UIViewControllerContextTransitioning> const transitionContext = self.transitionContext;
	kRUConditionalReturn_ReturnValueNil(transitionContext == nil, YES);
	
	CGRect const frameToUse = (self.isPresentation) ? [transitionContext finalFrameForViewController:self.toViewController] : [transitionContext initialFrameForViewController:self.fromViewController];
	
	CGFloat const cornerRadius = 13.0f;
	return [UIBezierPath
			bezierPathWithRoundedRect:frameToUse
			byRoundingCorners:UIRectCornerAllCorners
			cornerRadii:(CGSize){
				.height = cornerRadius,
				.width = cornerRadius,
			}];
}

#pragma mark - animatePresentation
-(void)animatePresentation
{
	id <UIViewControllerContextTransitioning> const transitionContext = self.transitionContext;
	kRUConditionalReturn(transitionContext == nil, YES);
	
	UIView* const toViewController_view = [transitionContext viewForKey:UITransitionContextToViewKey];
	
	CGRect const finalFrameFor_toViewController = toViewController_view.frame;
	
	UIView* const containerView = transitionContext.containerView;
	[containerView addSubview:toViewController_view];
	
	UIBezierPath* const startPath = self.referenceFrame_rounded_bezierPath;
	
	CAShapeLayer* const maskLayer = [CAShapeLayer new];
	[maskLayer setFrame:finalFrameFor_toViewController];
	[maskLayer setPath:startPath.CGPath];
	[toViewController_view.layer setMask:maskLayer];
	
	UIBezierPath* const endPath = self.fullscreenFrame_rounded_bezierPath;
	
	CABasicAnimation* const pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
	[pathAnimation setDelegate:self];
	[pathAnimation setFromValue:(__bridge id)startPath.CGPath];
	[pathAnimation setToValue:(__bridge id)endPath.CGPath];
	
	[pathAnimation setDuration:[self transitionDuration:transitionContext]];
	[maskLayer setPath:endPath.CGPath];
	[maskLayer addAnimation:pathAnimation forKey:@"path"];
}

#pragma mark - animateDismissal
-(void)animateDismissal
{
	id <UIViewControllerContextTransitioning> const transitionContext = self.transitionContext;
	kRUConditionalReturn(transitionContext == nil, YES);
	
	UIView* const fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
	CGRect const startFrame = fromView.frame;
	
	UIBezierPath* const startPath = self.fullscreenFrame_rounded_bezierPath;
	
	CAShapeLayer* const maskLayer = [CAShapeLayer new];
	[maskLayer setFrame:startFrame];
	[maskLayer setPath:startPath.CGPath];
	[fromView.layer setMask:maskLayer];
	
	UIBezierPath* const endPath = self.referenceFrame_rounded_bezierPath;
	
	CABasicAnimation* const pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
	[pathAnimation setDelegate:self];
	[pathAnimation setFromValue:(__bridge id)startPath.CGPath];
	[pathAnimation setToValue:(__bridge id)endPath.CGPath];
	[pathAnimation setDuration:[self transitionDuration:transitionContext]];
	
	[maskLayer setPath:endPath.CGPath];
	[maskLayer addAnimation:pathAnimation forKey:@"path"];
}

#pragma mark - fromViewController
-(nullable UIViewController*)fromViewController
{
	id <UIViewControllerContextTransitioning> const transitionContext = self.transitionContext;
	kRUConditionalReturn_ReturnValueNil(transitionContext == nil, YES);
	return [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
}

#pragma mark - toViewController
-(nullable UIViewController*)toViewController
{
	id <UIViewControllerContextTransitioning> const transitionContext = self.transitionContext;
	kRUConditionalReturn_ReturnValueNil(transitionContext == nil, YES);
	return [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
}

#pragma mark - CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	id <UIViewControllerContextTransitioning> const transitionContext = self.transitionContext;
	kRUConditionalReturn(transitionContext == nil, YES);
	
	if (self.isPresentation)
	{
		UIView* const toViewController_view = [transitionContext viewForKey:UITransitionContextToViewKey];
		[toViewController_view.layer.mask removeFromSuperlayer];
	}
	
	[transitionContext completeTransition:YES];
}

@end
