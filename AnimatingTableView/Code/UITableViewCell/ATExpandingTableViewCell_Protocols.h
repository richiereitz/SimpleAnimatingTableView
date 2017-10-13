//
//  ATExpandingTableViewCell_Protocols.h
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>





@class ATExpandingTableViewCell;





@protocol ATExpandingTableViewCell_beginAnimatedPresentationButton_didTouchUpInsideDelegate <NSObject>

-(void)expandingTableViewCell_beginAnimatedPresentationButton_didTouchUpInside:(nullable ATExpandingTableViewCell*)expandingTableViewCell
															 withReferenceRect:(CGRect)referenceRect;

@end
