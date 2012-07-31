//
//  MELangSelectViewController.m
//  Math Explorer
//
//  Created by Hyun Hwang on 7/5/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MELangSelectViewController.h"
#import "MEAppDelegate.h"
#import "METitleViewController.h"
#import "RINFindAct.h"


@implementation MELangSelectViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	[self setButton:MEButtonHome hidden:YES];
	[self setButton:MEButtonPrev hidden:YES];
	[self setButton:MEButtonNext hidden:YES];
}

-(IBAction)languageSelected:(id)sender {
	MEAppDelegate *d=(MEAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[d setLangCode:[sender tag]];
	
	switch([d langCode]) {
		case 1:
			[d setProblemID:1];
			break;
		case 2:
			[d setProblemID:289];
			break;
	}
	[RINFindAct removeFoundWord];
	[RINFindAct removeSentence];
	
	[[self navigationController] pushViewController:[[METitleViewController alloc] initWithNibName:@"METitleViewController" bundle:nil] animated:YES];
}

@end