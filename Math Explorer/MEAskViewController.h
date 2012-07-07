//
//  MEAskViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 7..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MEAskViewController:UIViewController{
	NSString *string[9];
	int nextString[9];
	int current;
}
@property(strong,nonatomic) IBOutlet UITextView *context;
@property(strong,nonatomic) IBOutlet UIButton *sound;
@property(strong,nonatomic) IBOutlet UIButton *no;
@property(strong,nonatomic) IBOutlet UIButton *yes;
@property(strong,nonatomic) IBOutlet UIButton *confirm;

-(IBAction)soundButtonAction:(id)sender;
-(IBAction)noButtonAction:(id)sender;
-(IBAction)yesButtonAction:(id)sender;
-(IBAction)confirmButtonAction:(id)sender;

@end