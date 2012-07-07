//
//  MEPageTemplateViewController.m
//  Math Explorer
//
//  Created by Hyun Hwang on 7/5/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"


@implementation MEPageTemplateViewController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft);
}

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	[[[self navigationController] navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
	
	// Background
	UIImageView *backgroundImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
	[backgroundImage setImage:[UIImage imageNamed:@"Background.png"]];
	[[self view] addSubview:backgroundImage];
	[[self view] sendSubviewToBack:backgroundImage];
	
	// Dictionary button
	utilDict=[UIButton buttonWithType:UIButtonTypeCustom];
	[utilDict setFrame:CGRectMake(332, 600, 128, 128)];
	[utilDict setTitle:@"Dict" forState:UIControlStateNormal];
	[utilDict addTarget:self action:@selector(dictButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[utilDict setHidden:YES];
	[[self view] addSubview:utilDict];
	
	// Say button
	utilSay=[UIButton buttonWithType:UIButtonTypeCustom];
	[utilSay setFrame:CGRectMake(468, 600, 128, 128)];
	[utilSay setBackgroundImage:[UIImage imageNamed:@"UtilSay.png"] forState:UIControlStateNormal];
	[utilSay addTarget:self action:@selector(sayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[utilSay setHidden:YES];
	[[self view] addSubview:utilSay];
	
	// Home button
	navHome=[UIButton buttonWithType:UIButtonTypeCustom];
	[navHome setFrame:CGRectMake(604, 600, 128, 128)];
	[navHome setBackgroundImage:[UIImage imageNamed:@"NavHome.png"] forState:UIControlStateNormal];
	[navHome addTarget:self action:@selector(homeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:navHome];
	
	// Prev button
	navPrev=[UIButton buttonWithType:UIButtonTypeCustom];
	[navPrev setFrame:CGRectMake(740, 600, 128, 128)];
	[navPrev setBackgroundImage:[UIImage imageNamed:@"NavPrev.png"] forState:UIControlStateNormal];
	[navPrev addTarget:self action:@selector(prevButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:navPrev];
	
	// Next button
	navNext=[UIButton buttonWithType:UIButtonTypeCustom];
	[navNext setFrame:CGRectMake(876, 600, 128, 128)];
	[navNext setBackgroundImage:[UIImage imageNamed:@"NavNext.png"] forState:UIControlStateNormal];
	[navNext addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:navNext];
}

-(void)dictButtonAction:(id)sender {
	@throw [NSException exceptionWithName:@"ButtonActionNotImplementedException" reason:@"Dictionary button's action is not implemented yet." userInfo:nil];
}

-(void)sayButtonAction:(id)sender {
	@throw [NSException exceptionWithName:@"ButtonActionNotImplementedException" reason:@"Say button's action is not implemented yet." userInfo:nil];
}

-(void)homeButtonAction:(id)sender {
	[[self navigationController] popToViewController:[[[self navigationController] viewControllers] objectAtIndex:1] animated:YES];
}

-(void)prevButtonAction:(id)sender {
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void)nextButtonAction:(id)sender {
	@throw [NSException exceptionWithName:@"ButtonActionNotImplementedException" reason:@"Next button's action is not implemented yet." userInfo:nil];
}

-(void)setButton:(MEButtonType)aButton hidden:(BOOL)hidden {
	UIButton *target=nil;
	
	switch(aButton) {
		case MEButtonDict:
			target=utilDict;
			break;
		case MEButtonSay:
			target=utilSay;
			break;
		case MEButtonHome:
			target=navHome;
			break;
		case MEButtonPrev:
			target=navPrev;
			break;
		case MEButtonNext:
			target=navNext;
			break;
	}
	dispatch_async(dispatch_get_main_queue(), ^{
		[target setHidden:hidden];
	});
}

@end