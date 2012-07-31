//
//  MELearningGoalViewController.m
//  Math Explorer
//
//  Created by Hyun Hwang on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MELearningGoalViewController.h"
#import "MEAppDelegate.h"
#import "MEProblemSelectionViewController.h"
#import "MEReadingTitleViewController.h"


@implementation MELearningGoalViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	[self setButton:MEButtonHome hidden:YES];
	[self setButton:MEButtonSay hidden:NO];
	
	[[meLearningGoalDetail scrollView] setScrollEnabled:NO];
	
	NSError *err=nil;
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	
	playerDetail=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.learning.goal.detail.0.%d.m4a",langCode]] error:&err];
	[playerDetail setVolume:1.0f];
	[playerDetail prepareToPlay];
	playerTitle=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.learning.goal.title.0.%d.m4a",langCode]] error:&err];
	[playerTitle setVolume:1.0f];
	[playerTitle prepareToPlay];
	
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.learning.goal.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[meLearningGoalTitle setTitle:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)] forState:UIControlStateNormal];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.learning.goal.detail" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	[meLearningGoalDetail loadHTMLString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)] baseURL:nil];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
}

-(void)sayButtonAction:(id)sender {
	if([playerDetail isPlaying]==NO) {
		[playerDetail setCurrentTime:0.0];
		[playerDetail play];
	} else
		[playerDetail stop];
}

-(IBAction)sayTitle:(id)sender {
	if([playerTitle isPlaying]==NO) {
		[playerTitle setCurrentTime:0.0];
		[playerTitle play];
	} else
		[playerTitle stop];
}

-(void)nextButtonAction:(id)sender {
	[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] setHomeBackup:[NSMutableArray arrayWithArray:[[self navigationController] viewControllers]]];
	[[self navigationController] setViewControllers:[NSArray arrayWithObject:[[MEReadingTitleViewController alloc] initWithNibName:@"MEReadingTitleViewController" bundle:nil]] animated:YES];
}

-(IBAction)trigerProblemSelection:(id)sender {
	MEProblemSelectionViewController *problemSelector=[[MEProblemSelectionViewController alloc] initWithNibName:@"MEProblemSelectionViewController" bundle:nil];
	[problemSelector setModalPresentationStyle:UIModalPresentationFormSheet];
	[self presentModalViewController:problemSelector animated:YES];
}

@end