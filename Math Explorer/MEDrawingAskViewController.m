//
//  MEDrawingAskViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEDrawingAskViewController.h"
#import "MEAppDelegate.h"

@implementation MEDrawingAskViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	NSInteger tn[10]={-1, -1, -1, 8, 7, -1, 7, -1, 4, 6};
	for(NSUInteger i=0; i<10; ++i)
		next[i]=tn[i];
	current=5;
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum ORDER BY relation ASC" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.drawing.ask.answer.no" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	for(NSInteger i=0; i<5; ++i) {
		sqlite3_step(localizer);
		string[i]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	}
	sqlite3_finalize(localizer);
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langnum" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.drawing.ask.question" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	string[5]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.drawing.ask.answer.yes" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	string[6]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.drawing.ask.finish" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	string[7]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.drawing.ask.answer" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	string[8]=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	string[9]=string[8];
	sqlite3_finalize(localizer);
	
	
	localizer=NULL;
	
	[meDrawingAsk setText:string[5]];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[meDrawingAsk setText:string[5]];
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
	[meDrawingAsk setText:string[noCount]];
	current=noCount;
	if(noCount<4)
		[super noButtonAction:sender];
	if(current==1) {
		NSString *urlStr;
		if(langCode==1) {
			urlStr=@"example.drawing.en.1";
		} else {
			urlStr=@"example.drawing.ko.1";
		}
		moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:urlStr ofType:@"m4v"]]];
		[[moviePlayer view] setFrame:CGRectMake(70, 247, 300, 225)];
		[[self view] addSubview:[moviePlayer view]];
		[moviePlayer setShouldAutoplay:YES];
		[moviePlayer play];
	} else if (current==2) {
		NSString *urlStr;
		if(langCode==1) {
			urlStr=@"example.drawing.en.2";
		} else {
			urlStr=@"example.drawing.ko.2";
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
	[meDrawingAsk setText:string[9]];
	current=9;
}

-(void)approveButtonAction:(id)sender {
	if(moviePlayer!=nil) {
		[[moviePlayer view] removeFromSuperview];
		moviePlayer=nil;
	}
	if(next[current]<0) {
		if(current==7) {
			[super approveButtonAction:sender];
		} else {
			[[self presentingViewController] dismissModalViewControllerAnimated:YES];
		}
	}
	else {
		[meDrawingAsk setText:string[next[current]]];
		current=next[current];
	}
}

-(void)sayButtonAction:(id)sender {
	NSString *fileFormat;
	switch (current) {
		case 0:fileFormat=@"me.drawing.ask.answer.no.0.%d.m4a";break;
		case 1:fileFormat=@"me.drawing.ask.answer.no.1.%d.m4a";break;
		case 2:fileFormat=@"me.drawing.ask.answer.no.2.%d.m4a";break;
		case 3:fileFormat=@"me.drawing.ask.answer.no.3.%d.m4a";break;
		case 4:fileFormat=@"me.drawing.ask.answer.no.4.%d.m4a";break;
		case 5:fileFormat=@"me.drawing.ask.question.0.%d.m4a";break;
		case 6:fileFormat=@"me.drawing.ask.answer.yes.0.%d.m4a";break;
		case 7:fileFormat=@"me.drawing.ask.finish.0.%d.m4a";break;
		default:fileFormat=@"me.drawing.ask.answer.0.%d.m4a";break;
	}
	NSError *err=nil;
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	playerAux=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:fileFormat, langCode,current]] error:&err];
	[playerAux setVolume:1.0f];
	[playerAux prepareToPlay];
	
	if([playerAux isPlaying]==NO) {
		[playerAux setCurrentTime:0.0];
		[playerAux play];
	} else
		[playerAux stop];
}

@end
