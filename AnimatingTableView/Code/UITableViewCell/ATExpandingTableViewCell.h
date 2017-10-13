//
//  ATExpandingTableViewCell.h
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import "ATExpandingTableViewCell_Protocols.h"

#import <UIKit/UIKit.h>





@class ATCellHelper;





@interface ATExpandingTableViewCell : UITableViewCell

#pragma mark - beginAnimatedPresentationButtonDelegate
@property (nonatomic, assign, nullable) id<ATExpandingTableViewCell_beginAnimatedPresentationButton_didTouchUpInsideDelegate>beginAnimatedPresentationButtonDelegate;

#pragma mark - roundedContentView
@property (nonatomic, readonly, strong, nullable) UIView* roundedContentView;

#pragma mark - cellHelper
@property (nonatomic, strong, nullable) ATCellHelper* cellHelper;

@end
