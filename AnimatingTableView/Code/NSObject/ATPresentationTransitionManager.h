//
//  ATPresentationTransitionManager.h
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>





@interface ATPresentationTransitionManager : NSObject <UIViewControllerTransitioningDelegate>

#pragma mark - referenceFrame
@property (nonatomic, assign) CGRect referenceFrame;

@end
