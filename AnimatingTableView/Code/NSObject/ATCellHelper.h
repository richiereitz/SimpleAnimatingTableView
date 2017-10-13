//
//  ATCellHelper.h
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface ATCellHelper : NSObject

#pragma mark - cellShouldShowButton
@property (nonatomic, assign) BOOL cellShouldShowButton;

@end





@interface ATCellHelper_PropertiesForKVO : NSObject

#pragma mark - cellShouldShowButton
+(nonnull NSString*)cellShouldShowButton;

@end
