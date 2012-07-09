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

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	NSInteger tn[8]={-1, -1, -1, 4, 7, -1, 7, -1};
	for(NSUInteger i=0; i<8; ++i)
		next[i]=tn[i];
	
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
	[chkNo setHidden:NO];
	[chkYes setHidden:NO];
	[chkAprv setHidden:YES];
}

-(void)noButtonAction:(id)sender {
	if(noCount<4)
		[super noButtonAction:sender];
	[chkAprv setHidden:NO];
	[chkNo setHidden:YES];
	[chkYes setHidden:YES];
	[meReadingAsk setText:string[noCount]];
}

-(void)yesButtonAction:(id)sender {
	noCount=6;
	[chkAprv setHidden:NO];
	[chkNo setHidden:YES];
	[chkYes setHidden:YES];
	[meReadingAsk setText:string[noCount]];
}

-(void)approveButtonAction:(id)sender {
	if(next[noCount]<0)
		[super approveButtonAction:sender];
	else {
		[meReadingAsk setText:string[next[noCount]]];
		noCount=next[noCount];
	}
}

@end