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


@implementation MELangSelectViewController

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	[self setButton:MEButtonHome hidden:YES];
	[self setButton:MEButtonPrev hidden:YES];
	[self setButton:MEButtonNext hidden:YES];
}

-(IBAction)languageSelected:(id)sender {
	MEAppDelegate *d=(MEAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[d setLangCode:[sender tag]];
	
	if([d langCode]==2)
		[d setProblemID:289];
	
	[[self navigationController] pushViewController:[[METitleViewController alloc] initWithNibName:@"METitleViewController" bundle:nil] animated:YES];
}

@end