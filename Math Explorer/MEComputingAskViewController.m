//
//  MEComputingAskViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEComputingAskViewController.h"
#import "MEAppDelegate.h"

@implementation MEComputingAskViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	NSInteger tn[11]={-1, -1, -1, 8, 7, -1, 7, 10, 4, 6,-1};
	for(NSUInteger i=0; i<11; ++i)
		next[i]=tn[i];
	current=5;
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum ORDER BY relation ASC" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.computing.ask.answer.no" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	for(NSInteger i=0; i<5; ++i) {
		sqlite3_step(localizer);
		string[i]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	}
	sqlite3_finalize(localizer);
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.computing.ask.question" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	string[5]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.computing.ask.answer.yes" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	string[6]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.computing.ask.finish" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	string[7]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.computing.ask.answer" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	string[8]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	string[9]=string[8];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.computing.ask.answer.computed" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	if(string[10]==0){
		string[10]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	}
	sqlite3_finalize(localizer);
	
	
	localizer=NULL;
	
	[meComputingAsk setText:string[5]];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[meComputingAsk setText:string[5]];
	current=5;
	[chkNo setHidden:NO];
	[chkYes setHidden:NO];
	[chkAprv setHidden:YES];
	if(moviePlayer!=nil) {
		[[moviePlayer view] removeFromSuperview];
		moviePlayer=nil;
	}
}

-(void)noButtonAction:(id)sender {
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	[chkNo setHidden:YES];
	[chkYes setHidden:YES];
	[chkAprv setHidden:NO];
	[meComputingAsk setText:string[noCount]];
	current=noCount;
	if(noCount<4)
		[super noButtonAction:sender];
	if(current==1) {
		NSString *urlStr;
		if(langCode==1) {
			urlStr=@"example.computing.en.1";
		} else {
			urlStr=@"example.computing.ko.1";
		}
		moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:urlStr ofType:@"m4v"]]];
		[[moviePlayer view] setFrame:CGRectMake(70, 247, 300, 225)];
		[[self view] addSubview:[moviePlayer view]];
		[moviePlayer setShouldAutoplay:YES];
		[moviePlayer play];
	} else if (current==2) {
		NSString *urlStr;
		if(langCode==1) {
			urlStr=@"example.computing.en.2";
		} else {
			urlStr=@"example.computing.ko.2";
		}
		moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:urlStr ofType:@"m4v"]]];
		[[moviePlayer view] setFrame:CGRectMake(70, 247, 300, 225)];
		[[self view] addSubview:[moviePlayer view]];
		[moviePlayer setShouldAutoplay:YES];
		[moviePlayer play];
	} else {
		if(moviePlayer!=nil) {
			[[moviePlayer view] removeFromSuperview];
			moviePlayer=nil;
		}
	}
}

-(void)yesButtonAction:(id)sender {
	[chkAprv setHidden:NO];
	[chkNo setHidden:YES];
	[chkYes setHidden:YES];
	[meComputingAsk setText:string[9]];
	current=9;
}

-(void)approveButtonAction:(id)sender {
	if(moviePlayer!=nil) {
		[[moviePlayer view] removeFromSuperview];
		moviePlayer=nil;
	}
	if(next[current]<0) {
		if(current==10) {
			[super approveButtonAction:sender];
		} else {
			[[self presentingViewController] dismissModalViewControllerAnimated:YES];
			[[NSNotificationCenter defaultCenter] postNotificationName:MEAskActivityDismissed object:self userInfo:nil];
		}
	}
	else {
		[meComputingAsk setText:string[next[current]]];
		current=next[current];
	}
}
-(void)setAnswer:(NSString *)ans correct:(NSString *)correct {
	static NSString *format=@"null";
	if([format isEqualToString:@"null"]) {
		NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
		sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
		sqlite3_stmt *localizer=NULL;
		sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum ORDER BY relation ASC" UTF8String], -1, &localizer, NULL);
		sqlite3_bind_text(localizer, 1, [@"me.computing.ask.answer.computed" UTF8String], -1, NULL);
		sqlite3_bind_int(localizer, 2, langCode);
		sqlite3_step(localizer);
		format=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
		sqlite3_finalize(localizer);
	}
	string[10]=[NSString stringWithFormat:format,correct,ans];
}

-(void)sayButtonAction:(id)sender {
	NSString *fileFormat;
	switch (current) {
		case 0:fileFormat=@"me.computing.ask.answer.no.0.%d.m4a";break;
		case 1:fileFormat=@"me.computing.ask.answer.no.1.%d.m4a";break;
		case 2:fileFormat=@"me.computing.ask.answer.no.2.%d.m4a";break;
		case 3:fileFormat=@"me.computing.ask.answer.no.3.%d.m4a";break;
		case 4:fileFormat=@"me.computing.ask.answer.no.4.%d.m4a";break;
		case 5:fileFormat=@"me.computing.ask.question.0.%d.m4a";break;
		case 6:fileFormat=@"me.computing.ask.answer.yes.0.%d.m4a";break;
		case 7:fileFormat=@"me.computing.ask.finish.0.%d.m4a";break;
		case 10:fileFormat=@"me.computing.ask.answer.computed.0.%d.m4a";break;
		default:fileFormat=@"me.computing.ask.answer.0.%d.m4a";break;
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
