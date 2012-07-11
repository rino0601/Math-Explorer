//
//  MEComputingDoViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEComputingDoViewController.h"
#import "MEAppDelegate.h"
#import "MEComputingAskViewController.h"
#import "MEBTFViewController.h"

@implementation MEComputingDoViewController

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	isGoodToContinue=NO;
	meComputingAskActivity=[[MEComputingAskViewController alloc] initWithNibName:@"MEComputingAskViewController" bundle:nil];
	
	/*// Dictionary button
	 UIButton *utilDict=[UIButton buttonWithType:UIButtonTypeCustom];
	 [utilDict setFrame:CGRectMake(332, 600, 128, 128)];
	 [utilDict setTitle:@"Dict" forState:UIControlStateNormal];//@
	 [utilDict addTarget:self action:@selector(dictButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	 [[self view] addSubview:utilDict];
	 //*/
	[self setButton:MEButtonSay hidden:NO];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langcode" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.computing.do.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[self setTitle:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.computing.do.instruction" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	[meComputingDoInstruction setText:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
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

-(void)nextButtonAction:(id)sender {
	if(isGoodToContinue==NO) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToContinue:) name:MEAskActivityConfirmed object:nil];
		[meComputingAskActivity setModalPresentationStyle:UIModalPresentationFormSheet];
		
		[self presentModalViewController:meComputingAskActivity animated:YES];
	} else {
		[[self navigationController] pushViewController:[[MEBTFViewController alloc] initWithNibName:@"MEBTFViewController" bundle:nil] animated:YES];
	}
}

-(void)readyToContinue:(NSNotification *)notif {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MEAskActivityConfirmed object:nil];
	isGoodToContinue=YES;
}

@end
