//
//  MEFindingTitleViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 9..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEFindingTitleViewController.h"
#import "MEAppDelegate.h"
#import "MEFindingDoViewController.h"

@implementation MEFindingTitleViewController
-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.finding.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[meFindingTitle setText:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
}

-(void)nextButtonAction:(id)sender {
	[[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] vcBackups] addObject:[NSMutableArray arrayWithArray:[[self navigationController] viewControllers]]];
	[[self navigationController] setViewControllers:[NSArray arrayWithObject:[[MEFindingDoViewController alloc] initWithNibName:@"MEFindingDoViewController" bundle:nil]] animated:YES];
	//[[self navigationController] setViewControllers:[NSArray arrayWithObject:[[MEReadingDoViewController alloc] initWithNibName:@"MEReadingDoViewController" bundle:nil]] animated:YES];
}

@end
