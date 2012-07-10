//
//  MEFindingAskViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 9..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEFindingAskViewController.h"
#import "MEAppDelegate.h"

@implementation MEFindingAskViewController

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	NSInteger tn[10]={-1, -1, -1, 8, 7, -1, 7, -1, 4, 6};
	for(NSUInteger i=0; i<10; ++i)
		next[i]=tn[i];
	current=5;
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum ORDER BY relation ASC" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.finding.ask.answer.no" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	for(NSInteger i=0; i<5; ++i) {
		sqlite3_step(localizer);
		string[i]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	}
	sqlite3_finalize(localizer);
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.finding.ask.question" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	string[5]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.finding.ask.answer.yes" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	string[6]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.finding.ask.finish" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	string[7]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.finding.ask.answer" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	string[8]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	string[9]=string[8];
	sqlite3_finalize(localizer);
	
	
	localizer=NULL;
	
	[meFindingAsk setText:string[5]];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[meFindingAsk setText:string[5]];
	current=5;
	[chkNo setHidden:NO];
	[chkYes setHidden:NO];
	[chkAprv setHidden:YES];
}

-(void)noButtonAction:(id)sender {
	[chkAprv setHidden:NO];
	[chkNo setHidden:YES];
	[chkYes setHidden:YES];
	[meFindingAsk setText:string[noCount]];
	current=noCount;
	if(noCount<4)
		[super noButtonAction:sender];
}

-(void)yesButtonAction:(id)sender {
	[chkAprv setHidden:NO];
	[chkNo setHidden:YES];
	[chkYes setHidden:YES];
	[meFindingAsk setText:string[9]];
	current=9;
}

-(void)approveButtonAction:(id)sender {
	if(next[current]<0) {
		if(current==7)
			[super approveButtonAction:sender];
		else
			[[self presentingViewController] dismissModalViewControllerAnimated:YES];
	}
	else {
		[meFindingAsk setText:string[next[current]]];
		current=next[current];
	}
}

@end
