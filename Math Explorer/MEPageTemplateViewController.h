//
//  MEPageTemplateViewController.h
//  Math Explorer
//
//  Created by Hyun Hwang on 7/5/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
	MEButtonSay=1,
	MEButtonHome=2,
	MEButtonPrev=4,
	MEButtonNext=8
} MEButtonType;

@interface MEPageTemplateViewController:UIViewController {
	@protected
	UIButton *utilSay, *navHome, *navPrev, *navNext;
	UIImageView *backgroundImage;
}

-(void)sayButtonAction:(id)sender;
-(void)homeButtonAction:(id)sender;
-(void)prevButtonAction:(id)sender;
-(void)nextButtonAction:(id)sender;

-(void)setButton:(MEButtonType)aButton hidden:(BOOL)hidden;

@end