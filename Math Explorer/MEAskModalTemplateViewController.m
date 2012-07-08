//
//  MEAskViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEAskViewController.h"


NSString *const MEReadingAskActivityConfirmed=@"Nothing interesting here.";

@implementation MEAskViewController

@synthesize context;

//@dbg
-(void)viewDidLoad {
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
}

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	// load
	
	// Background
	UIImageView *backgroundImage=[[UIImageView alloc] initWithFrame:CGRectMake(0-(1024-540)/2, 0-(768-620)/2, 1024, 768)];
	[backgroundImage setImage:[UIImage imageNamed:@"Background.png"]];
	[[self view] addSubview:backgroundImage];
	[[self view] sendSubviewToBack:backgroundImage];
	
	[context setText:string[0]];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[chkAprv setHidden:YES];
	[chkYes setHidden:NO];
	[chkNo setHidden:NO];
	[context setText:string[0]];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft);
}

-(IBAction)sayButtonAction:(id)sender {
	//
}

-(IBAction)noButtonAction:(id)sender {
	[chkAprv setHidden:NO];
	[chkYes setHidden:YES];
	[chkNo setHidden:YES];
	
	[context setText:string[nextString[0]]];
	current=nextString[0];
	if(nextString[0]<4)
		nextString[0]++;
}

-(IBAction)yesButtonAction:(id)sender {
	[chkAprv setHidden:NO];
	[chkYes setHidden:YES];
	[chkNo setHidden:YES];
	
	[context setText:string[8]];
	current=8;
}

-(IBAction)ApproveButtonAction:(id)sender {
	if(nextString[current]!=9) {
		[context setText:string[nextString[current]]];
		current=nextString[current];
	} else {
		if(current==7)
			[[NSNotificationCenter defaultCenter] postNotificationName:MEReadingAskActivityConfirmed object:self];
		[self dismissModalViewControllerAnimated:YES];
	}
}

@end