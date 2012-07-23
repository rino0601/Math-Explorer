//
//  MEReadingAskViewController.m
//  Math Explorer
//
//  Created by Hyun Hwang on 7/8/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEReadingAskViewController.h"
#import "MEAppDelegate.h"


@implementation MEReadingAskViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	NSInteger tn[8]={-1, -1, -1, 4, 7, -1, 7, -1};
	for(NSUInteger i=0; i<8; ++i)
		next[i]=tn[i];
	current=5;
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum ORDER BY relation ASC" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.reading.ask.answer.no" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	for(NSInteger i=0; i<5; ++i) {
		sqlite3_step(localizer);
		string[i]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	}
	sqlite3_finalize(localizer);
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.reading.ask.question" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	string[5]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.reading.ask.answer.yes" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	string[6]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.reading.ask.finish" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	string[7]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
	
	[meReadingAsk setText:string[5]];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[meReadingAsk setText:string[5]];
	current=5;
	[chkNo setHidden:NO];
	[chkYes setHidden:NO];
	[chkAprv setHidden:YES];
}

-(void)noButtonAction:(id)sender {
	[chkAprv setHidden:NO];
	[chkNo setHidden:YES];
	[chkYes setHidden:YES];
	[meReadingAsk setText:string[noCount]];
	current=noCount;
	if(noCount<4)
		[super noButtonAction:sender];
}

-(void)yesButtonAction:(id)sender {
	[chkAprv setHidden:NO];
	[chkNo setHidden:YES];
	[chkYes setHidden:YES];
	[meReadingAsk setText:string[6]];
	current=6;
}

-(void)approveButtonAction:(id)sender {
	if(next[current]<0) {
		if(current==7){
			[super approveButtonAction:sender];
		} else {
		 	[[self presentingViewController] dismissModalViewControllerAnimated:YES];
			[[NSNotificationCenter defaultCenter] postNotificationName:MEAskActivityDismissed object:self userInfo:nil];
		}
	}
	else {
		[meReadingAsk setText:string[next[current]]];
		current=next[current];
	}
}

-(void)sayButtonAction:(id)sender {
	NSString *fileFormat;
	switch (current) {
		case 0:fileFormat=@"me.reading.ask.answer.no.0.%d.m4a";break;
		case 1:fileFormat=@"me.reading.ask.answer.no.1.%d.m4a";break;
		case 2:fileFormat=@"me.reading.ask.answer.no.2.%d.m4a";break;
		case 3:fileFormat=@"me.reading.ask.answer.no.3.%d.m4a";break;
		case 4:fileFormat=@"me.reading.ask.answer.no.4.%d.m4a";break;
		case 5:fileFormat=@"me.reading.ask.question.0.%d.m4a";break;
		case 6:fileFormat=@"me.reading.ask.answer.yes.0.%d.m4a";break;
		case 7:fileFormat=@"me.reading.ask.finish.0.%d.m4a";break;
		default:break;
	}
	NSError *err=nil;
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:fileFormat, langCode,current]] error:&err];
	[avp setVolume:1.0f];
	[avp prepareToPlay];
	
	if([avp isPlaying]==NO) {
		[avp setCurrentTime:0.0];
		[avp play];
	} else
		[avp stop];
}

@end