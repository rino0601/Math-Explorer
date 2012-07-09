//
//  MEFindingDoViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 9..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEFindingDoViewController.h"
#import "MEAppDelegate.h"
#import "MEFindingAskViewController.h"
//#import "next View controller"

@implementation MEFindingDoViewController

-(void) viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	meFindingAskActivity=[[MEFindingAskViewController alloc] initWithNibName:@"MEFindingAskViewController" bundle:nil];
	
	// Say button unhidden
	[self setButton:MEButtonSay hidden:NO];
	
	
}

-(void)sayButtonAction:(id)sender {
	//
}

-(void)homeButtonAction:(id)sender {
	NSMutableArray *restoring=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] homeBackup];
	[restoring removeLastObject];
	[restoring addObject:self];
	[[self navigationController] setViewControllers:restoring animated:NO];
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void)prevButtonAction:(id)sender {
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void)nextButtonAction:(id)sender {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToContinue:) name:MEAskActivityConfirmed object:nil];
	[meFindingAskActivity setModalPresentationStyle:UIModalPresentationFormSheet];
	
	[self presentModalViewController:meFindingAskActivity animated:YES];
}

-(void)readyToContinue:(NSNotification *)notif {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MEAskActivityConfirmed object:nil];
//	[[self navigationController] setViewControllers:[NSArray arrayWithObject:[[MEFindingTitleViewController alloc] initWithNibName:@"MEFindingTitleViewController" bundle:nil]] animated:YES];
}



@end
