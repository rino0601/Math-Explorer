//
//  METitleViewController.m
//  Math Explorer
//
//  Created by Hyun Hwang on 7/6/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "METitleViewController.h"
#import "MEAppDelegate.h"
#import "MELearningGoalViewController.h"

#import "MEFindingDoViewController.h"

@implementation METitleViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	[self setButton:MEButtonHome hidden:YES];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[meTitle setText:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.subtitle" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	[meSubtitle setText:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
}

-(void)nextButtonAction:(id)sender {
	[[self navigationController] pushViewController:[[MELearningGoalViewController alloc] initWithNibName:@"MELearningGoalViewController" bundle:nil] animated:YES];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch =[[event allTouches] anyObject];
	if(CGRectContainsPoint([meTitle frame], [touch locationInView:[self view]])) {
		NSError *err=nil;
		NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
		avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.title.0.%d.m4a",langCode]] error:&err];
		[avp setVolume:1.0f];
		[avp prepareToPlay];
		
		if([avp isPlaying]==NO) {
			[avp setCurrentTime:0.0];
			[avp play];
		} else
			[avp stop];
	}
	
	if(CGRectContainsPoint([meSubtitle frame], [touch locationInView:[self view]])) {
		NSError *err=nil;
		NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
		avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.subtitle.0.%d.m4a",langCode]] error:&err];
		[avp setVolume:1.0f];
		[avp prepareToPlay];
		
		if([avp isPlaying]==NO) {
			[avp setCurrentTime:0.0];
			[avp play];
		} else
			[avp stop];
	}
}

@end