//
//  ATModalViewController_Protocols.h
//  AnimatingTableView
//
//  Created by Richard Reitzfeld on 10/13/17.
//  Copyright © 2017 Richard Reitzfeld. All rights reserved.
//

#import <Foundation/Foundation.h>





@class ATModalViewController;





@protocol ATModalViewController_dismissalDelegate <NSObject>

-(void)modalViewController_dismissButton_didTouchUpInside;

@end
