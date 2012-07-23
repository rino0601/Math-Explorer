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

-(void)viewDidLoad {
	[super viewDidLoad];
	
	[[self navigationController] setNavigationBarHidden:NO animated:NO];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.reading.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[meReadingTitle setText:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	[self setTitle:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
}

-(void)homeButtonAction:(id)sender {
	[[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] homeBackup] removeLastObject];
	
	[self prevButtonAction:sender];
}

-(void)prevButtonAction:(id)sender {
	NSMutableArray *restoring=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] homeBackup];
	[restoring addObject:self];
	[[self navigationController] setViewControllers:restoring animated:NO];
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void)nextButtonAction:(id)sender {
	[[self navigationController] pushViewController:[[MEReadingDoViewController alloc] initWithNibName:@"MEReadingDoViewController" bundle:nil] animated:YES];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch =[[event allTouches] anyObject];
	if(CGRectContainsPoint([meReadingTitle frame], [touch locationInView:[self view]])) {
		NSError *err=nil;
		NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
		avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.reading.title.0.%d.m4a",langCode]] error:&err];
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