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
#import "MEReadingTitleViewController.h"

@implementation MEFindingTitleViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.finding.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[meFindingTitle setText:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	[self setTitle:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
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
	NSMutableArray *goingBack=[NSMutableArray arrayWithObject:[[MEReadingTitleViewController alloc] initWithNibName:@"MEReadingTitleViewController" bundle:nil]];
	[goingBack addObject:self];
	[[self navigationController] setViewControllers:goingBack animated:NO];
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void)nextButtonAction:(id)sender {
	[[self navigationController] pushViewController:[[MEFindingDoViewController alloc] initWithNibName:@"MEFindingDoViewController" bundle:nil] animated:YES];
}

@end
