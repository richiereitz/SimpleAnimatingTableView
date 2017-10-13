//
//  ATModalViewController.h
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import "ATModalViewController_Protocols.h"

#import <UIKit/UIKit.h>





@interface ATModalViewController : UIViewController

#pragma mark - dismissButtonDelegate
@property (nonatomic, assign) id<ATModalViewController_dismissalDelegate> dismissButtonDelegate;

@end
