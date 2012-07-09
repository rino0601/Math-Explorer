//
//  MELearningGoalViewController.m
//  Math Explorer
//
//  Created by Hyun Hwang on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MELearningGoalViewController.h"
#import "MEAppDelegate.h"
#import "MEReadingTitleViewController.h"


@implementation MELearningGoalViewController

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	[self setButton:MEButtonSay hidden:NO];
	
	NSError *err=nil;
	
	avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"me.learning.goal.detail.m4a"] error:&err];
	[avp setVolume:1.0f];
	[avp prepareToPlay];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.learning.goal.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[meLearningGoalTitle setText:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.learning.goal.detail" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	[meLearningGoalDetail loadHTMLString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)] baseURL:nil];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
}

-(void)sayButtonAction:(id)sender {
	if([avp isPlaying]==NO) {
		[avp setCurrentTime:0.0];
		[avp play];
	} else
		[avp stop];
}

-(void)nextButtonAction:(id)sender {
	[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] setHomeBackup:[NSMutableArray arrayWithArray:[[self navigationController] viewControllers]]];
	[[self navigationController] setViewControllers:[NSArray arrayWithObject:[[MEReadingTitleViewController alloc] initWithNibName:@"MEReadingTitleViewController" bundle:nil]] animated:YES];
}

@end