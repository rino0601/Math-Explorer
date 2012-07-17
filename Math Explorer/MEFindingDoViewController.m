//
//  MEFindingDoViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 9..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEFindingDoViewController.h"
#import "MEAppDelegate.h"
#import "MEFindingAskViewController.h"
#import "MEDrawingTitleViewController.h"
#import "RINFindAct.h"


@implementation MEFindingDoViewController

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	isGoodToContinue=NO;
	meFindingAskActivity=[[MEFindingAskViewController alloc] initWithNibName:@"MEFindingAskViewController" bundle:nil];
	
	// optional(or test) area
	
	[self setButton:MEButtonSay hidden:NO];
	NSError *err=nil;
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode],problemID=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] problemID];

	avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.problem.%d.%03d.m4a", langCode, problemID]] error:&err];
	[avp setVolume:1.0f];
	[avp prepareToPlay];
	
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	NSString *problem;
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langcode" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.finding.do.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[self setTitle:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.finding.do.instruction" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	[mefindingDoInstruction setText:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_finalize(localizer);
	
	sqlite3_prepare_v2(dbo, [@"SELECT problem_strings.string, problem_nouns.sv1, problem_nouns.sv2, problem_nouns.ov1, problem_nouns.ov2, problem_numbers.nv1, problem_numbers.nv2 FROM problems, problem_strings, problem_nouns, problem_numbers WHERE problems.id=:problemid AND problems.lang=:langcode AND problem_strings.id=problems.string_id AND problem_nouns.id=problems.noun_id AND problem_numbers.id=problems.number_id" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_int(localizer, 1, problemID);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	const char *sv1=(const char *)sqlite3_column_text(localizer, 1), *sv2=(const char *)sqlite3_column_text(localizer, 2), *ov1=(const char *)sqlite3_column_text(localizer, 3), *ov2=(const char *)sqlite3_column_text(localizer, 4);
	char emptstr[1]={0};
	problem=[NSString stringWithFormat:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)], sv1==NULL?emptstr:sv1, sv2==NULL?emptstr:sv2, ov1==NULL?emptstr:ov1, ov2==NULL?emptstr:ov2, sqlite3_column_int(localizer, 5), sqlite3_column_int(localizer, 6)];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
	
	NSArray *container=[problem componentsSeparatedByString:@" "];
	NSArray *importantArray=[NSArray arrayWithObjects:@"Becky",@"apples",nil];
	
	RINFindAct *prev=nil;
	for(NSString *key in container) {
		RINFindAct *now=[RINFindAct alloc];
		if(prev!=nil) {
			[prev setRear:now];
		}
		now = [now initWithString:key Front:prev Frame:CGRectMake(20, 250, 984, 350)];
		for(NSString *subkey in importantArray) {
			if([key hasPrefix:subkey]) {
				[now setImportant:YES];
			}
		}
		[self.view addSubview:now];
		prev= now;
	}
	
}

-(void)sayButtonAction:(id)sender {
	if([avp isPlaying]==NO) {
		[avp setCurrentTime:0.0];
		[avp play];
	} else
		[avp stop];
}

-(void)nextButtonAction:(id)sender {
	
	NSMutableString *answer = [[NSMutableString alloc] init];
	[answer appendString:@"\""];
	for(NSString *key in [RINFindAct foundWord]) {
		[answer appendFormat:@"%@,",key];
	}
	answer=[[NSMutableString alloc] initWithString:[answer substringToIndex:[answer length]-1]];
	[answer appendString:@"\""];
	[meFindingAskActivity setMyAnswer:answer];
	
	if(isGoodToContinue==NO) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToContinue:) name:MEAskActivityConfirmed object:nil];
		[meFindingAskActivity setModalPresentationStyle:UIModalPresentationFormSheet];

		[self presentModalViewController:meFindingAskActivity animated:YES];
	} else {
		[[self navigationController] setViewControllers:[NSArray arrayWithObject:[[MEDrawingTitleViewController alloc] initWithNibName:@"MEDrawingTitleViewController" bundle:nil]] animated:YES];
	}
}

-(void)readyToContinue:(NSNotification *)notif {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MEAskActivityConfirmed object:nil];
	isGoodToContinue=YES;
	
}

@end