//
//  ATPresentationAnimationManager.h
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>





@interface ATPresentationAnimationManager : NSObject <UIViewControllerAnimatedTransitioning>

#pragma mark - referenceFrame
@property (nonatomic, assign) CGRect referenceFrame;

#pragma mark - isPresentation
@property (nonatomic, assign) BOOL isPresentation;

@end
