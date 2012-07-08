//
//  MEAskViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const MEReadingAskActivityConfirmed;

@interface MEAskViewController:UIViewController{
	@private
	NSString *string[9];
	NSUInteger nextString[9];
	NSUInteger current;
	IBOutlet UIButton *utilSay, *chkNo, *chkYes, *chkAprv;
}

@property(strong,nonatomic) IBOutlet UITextView *context;

-(IBAction)sayButtonAction:(id)sender;
-(IBAction)noButtonAction:(id)sender;
-(IBAction)yesButtonAction:(id)sender;
-(IBAction)ApproveButtonAction:(id)sender;

@end