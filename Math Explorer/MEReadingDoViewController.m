//
//  MEReadingDoViewController.m
//  Math Explorer
//
//  Created by Hyun Hwang on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEReadingDoViewController.h"
#import "MEAppDelegate.h"



@implementation MEReadingDoViewController

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langcode" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.reading.do.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[self setTitle:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
}

-(void)homeButtonAction:(id)sender {
	[[[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] vcBackups] lastObject] removeObjectsInRange:NSMakeRange(2, 2)];
	
	[self prevButtonAction:sender];
}

-(void)prevButtonAction:(id)sender {
	NSMutableArray *backups=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] vcBackups];
	NSMutableArray *restoring=[backups lastObject];
	[backups removeLastObject];
	[restoring addObject:self];
	[[self navigationController] setViewControllers:restoring animated:NO];
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void)nextButtonAction:(id)sender {
	//
}

@end
