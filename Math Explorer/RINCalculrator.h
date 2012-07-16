//
//  RINCalculrator.h
//  RINCalculratorModule
//
//  Created by rino0601 on 12. 4. 11..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RINCalculratorDelegate;

@interface RINCalculrator : UIView {
}
@property int nv1,nv2,correct;
@property id<RINCalculratorDelegate> viewController;
- (void) PressTutorialButton:(id)sender event:(UIEvent *)e;
@end

@protocol RINCalculratorDelegate <NSObject>

@optional
-(void)submitUserAnswerWithValues:(NSArray *)values;
@end