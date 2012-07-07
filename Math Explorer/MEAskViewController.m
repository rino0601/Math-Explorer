//
//  MEAskViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEAskViewController.h"


@implementation MEAskViewController
@synthesize yes,confirm,context,no,sound;
-(void)viewDidLoad{
	[super viewDidLoad];
	string[0]=@"Have I read and understood the problem?";
	string[1]=@"Read each sentence.\nThen read all the problem.";
	string[2]=@"Click sound button to hear the problem.";
	string[3]=@"Click any word If you don't know its meaning.";
	string[4]=@"Ask my teacher to help me read the problem.";
	string[5]=@"";
	string[6]=@"You tried very hard!\nKeep trying!\nYou can get it next time!";
	string[7]=@"I understand the problem.\nI read the problem again.";
	string[8]=@"Good work!\nYou really know this!";
	nextString[0]=1;
	nextString[1]=9;
	nextString[2]=9;
	nextString[3]=9;
	nextString[4]=6;
	nextString[5]=9;
	nextString[6]=7;
	nextString[7]=9;
	nextString[8]=7;
	[context setText:string[0]];
}
-(void)viewWillAppear:(BOOL)animated{
	[confirm setHidden:YES];
	[yes setHidden:NO];
	[no setHidden:NO];
	[context setText:string[0]];
}
-(IBAction)confirmButtonAction:(id)sender{
	if(nextString[current]!=9){
		[context setText:string[nextString[current]]];
		current=nextString[current];
	}else{
		if(current==7)[[NSNotificationCenter defaultCenter] postNotificationName:@"allowed" object:self];
		[self dismissModalViewControllerAnimated:YES];
	}
}
-(IBAction)noButtonAction:(id)sender{
	[confirm setHidden:NO];
	[yes setHidden:YES];
	[no setHidden:YES];
	[context setText:string[nextString[0]]];
	current=nextString[0];
	if(nextString[0]<4) nextString[0]++;
}
-(IBAction)yesButtonAction:(id)sender{
	[confirm setHidden:NO];
	[yes setHidden:YES];
	[no setHidden:YES];
	[context setText:string[8]];
	current=8;
}
-(IBAction)soundButtonAction:(id)sender{
	
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft);
}

@end