//
//  MEReadingDoViewController.m
//  Math Explorer
//
//  Created by Hyun Hwang on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEReadingDoViewController.h"
#import "MEAppDelegate.h"
#import "MEDictionaryViewController.h"
#import "MEReadingAskViewController.h"
#import "MEFindingTitleViewController.h"


@implementation MEReadingDoViewController

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	meReadingAskActivity=[[MEReadingAskViewController alloc] initWithNibName:@"MEReadingAskViewController" bundle:nil];
	
	// Dictionary button
	UIButton *utilDict=[UIButton buttonWithType:UIButtonTypeCustom];
	[utilDict setFrame:CGRectMake(332, 600, 128, 128)];
	[utilDict setTitle:@"Dict" forState:UIControlStateNormal];//@
	[utilDict addTarget:self action:@selector(dictButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:utilDict];
	[self setButton:MEButtonSay hidden:NO];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langcode" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.reading.do.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[self setTitle:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.reading.do.instruction" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	[meReadingDoInstruction setText:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
}

-(void)dictButtonAction:(id)sender {
	MEDictionaryViewController *dict=[[MEDictionaryViewController alloc] init];
	[dict setModalPresentationStyle:UIModalPresentationFullScreen];
	[self presentModalViewController:dict animated:YES];
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
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void)nextButtonAction:(id)sender {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToContinue:) name:MEAskActivityConfirmed object:nil];
	[meReadingAskActivity setModalPresentationStyle:UIModalPresentationFormSheet];
	
	[self presentModalViewController:meReadingAskActivity animated:YES];
}

-(void)readyToContinue:(NSNotification *)notif {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MEAskActivityConfirmed object:nil];
	[[self navigationController] setViewControllers:[NSArray arrayWithObject:[[MEFindingTitleViewController alloc] initWithNibName:@"MEFindingTitleViewController" bundle:nil]] animated:YES];
}

@end
