//
//  MEReadingTitleViewController.m
//  Math Explorer
//
//  Created by Hyun Hwang on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEReadingTitleViewController.h"
#import "MEAppDelegate.h"
#import "MEReadingDoViewController.h"


@implementation MEReadingTitleViewController

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.reading.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[meReadingTitle setText:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
}

-(void)nextButtonAction:(id)sender {
	[[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] vcBackups] addObject:[NSMutableArray arrayWithArray:[[self navigationController] viewControllers]]];
	[[self navigationController] setNavigationBarHidden:NO animated:NO];
	
	[[self navigationController] setViewControllers:[NSArray arrayWithObject:[[MEReadingDoViewController alloc] initWithNibName:@"MEReadingDoViewController" bundle:nil]] animated:YES];
}

@end