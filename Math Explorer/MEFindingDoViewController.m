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

-(void)viewDidLoad{
	[super viewDidLoad];
	
	isGoodToContinue=NO;
	meFindingAskActivity=[[MEFindingAskViewController alloc] initWithNibName:@"MEFindingAskViewController" bundle:nil];
	
	[self setButton:MEButtonSay hidden:NO];
	
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode],problemID=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] problemID];
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
	
	//load&set problem.
	sqlite3_prepare_v2(dbo, [@"SELECT problem_strings.string, problem_nouns.sv1, problem_nouns.sv2, problem_nouns.ov1, problem_nouns.ov2, problem_numbers.nv1, problem_numbers.nv2 FROM problems, problem_strings, problem_nouns, problem_numbers WHERE problems.id=:problemid AND problems.lang=:langcode AND problem_strings.id=problems.string_id AND problem_nouns.id=problems.noun_id AND problem_numbers.id=problems.number_id" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_int(localizer, 1, problemID);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	const char *_sv1=(const char *)sqlite3_column_text(localizer, 1), *_sv2=(const char *)sqlite3_column_text(localizer, 2), *_ov1=(const char *)sqlite3_column_text(localizer, 3), *_ov2=(const char *)sqlite3_column_text(localizer, 4);
	NSString *sv1=(_sv1==NULL?[NSString string]:[NSString stringWithUTF8String:_sv1]),*sv2=(_sv2==NULL?[NSString string]:[NSString stringWithUTF8String:_sv2]),*ov1=(_ov1==NULL?[NSString string]:[NSString stringWithUTF8String:_ov1]),*ov2=(_ov2==NULL?[NSString string]:[NSString stringWithUTF8String:_ov2]),*nv1=([NSString stringWithFormat:@"%d",sqlite3_column_int(localizer, 5)]),*nv2=([NSString stringWithFormat:@"%d",sqlite3_column_int(localizer, 6)]);
	NSString *problem=[NSString stringWithFormat:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)], sv1, sv2, ov1, ov2, sqlite3_column_int(localizer, 5), sqlite3_column_int(localizer, 6)];
	sqlite3_finalize(localizer);
	
	//load keywords.
	sqlite3_prepare_v2(dbo, [@"SELECT problem_keywords.keywords FROM problems, problem_keywords WHERE problems.id=:problemid AND problem_keywords.string_id=problems.string_id" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_int(localizer, 1, problemID);
	sqlite3_step(localizer);
	NSString *important=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_finalize(localizer);
	NSMutableArray *keywords=[[NSMutableArray alloc] init];
	[keywords addObject:sv1];[keywords addObject:sv2];[keywords addObject:ov1];[keywords addObject:ov2];[keywords addObject:nv1];[keywords addObject:nv2];
	[keywords addObjectsFromArray:[important componentsSeparatedByString:@"@"]];
	
	localizer=NULL;
	
	mArray=[RINFindAct makeRINFindActView:[self view] Frame:CGRectMake(20, 250, 984, 350) String:problem Important:keywords];
	
	UITapGestureRecognizer* tapRecon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationBarTap:)];
    tapRecon.numberOfTapsRequired = 1;
	[[self.navigationController.navigationBar.subviews objectAtIndex:0] setUserInteractionEnabled:YES];
    [[self.navigationController.navigationBar.subviews objectAtIndex:0] addGestureRecognizer:tapRecon];
}

-(void)navigationBarTap:(UIGestureRecognizer *)recognizer {
	NSError *err=nil;
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.finding.do.title.0.%d.m4a",langCode]] error:&err];
	[avp setVolume:1.0f];
	[avp prepareToPlay];
	if([avp isPlaying]==NO) {
		[avp setCurrentTime:0.0];
		[avp play];
	} else
		[avp stop];
}

-(void)sayButtonAction:(id)sender {
	NSError *err=nil;
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode],problemID=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] problemID];
	
	avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.problem.%d.%03d.m4a", langCode, (langCode==2?problemID-288:problemID)]] error:&err];
	[avp setVolume:1.0f];
	[avp prepareToPlay];
	
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
		[answer appendFormat:@" %@,",key];
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

-(void)problemChange:(NSNotification *)notif {
	//remove notification observer.
	//[[NSNotificationCenter defaultCenter] removeObserver:self name:MEAskActivityDismissed object:nil];
	
	return ;
	//load DB.
	NSError *err=nil;
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode], problemID=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] nextProblem];
	sqlite3_stmt *localizer=NULL;
	
	//load&set sound.
	avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.problem.%d.%03d.m4a", langCode, (langCode==2?problemID-288:problemID)]] error:&err];
	[avp setVolume:1.0f];
	[avp prepareToPlay];
	
	//load&set problem.
	sqlite3_prepare_v2(dbo, [@"SELECT problem_strings.string, problem_nouns.sv1, problem_nouns.sv2, problem_nouns.ov1, problem_nouns.ov2, problem_numbers.nv1, problem_numbers.nv2 FROM problems, problem_strings, problem_nouns, problem_numbers WHERE problems.id=:problemid AND problems.lang=:langcode AND problem_strings.id=problems.string_id AND problem_nouns.id=problems.noun_id AND problem_numbers.id=problems.number_id" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_int(localizer, 1, problemID);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	const char *_sv1=(const char *)sqlite3_column_text(localizer, 1), *_sv2=(const char *)sqlite3_column_text(localizer, 2), *_ov1=(const char *)sqlite3_column_text(localizer, 3), *_ov2=(const char *)sqlite3_column_text(localizer, 4);
	NSString *sv1=(_sv1==NULL?[NSString string]:[NSString stringWithUTF8String:_sv1]),*sv2=(_sv2==NULL?[NSString string]:[NSString stringWithUTF8String:_sv2]),*ov1=(_ov1==NULL?[NSString string]:[NSString stringWithUTF8String:_ov1]),*ov2=(_ov2==NULL?[NSString string]:[NSString stringWithUTF8String:_ov2]),*nv1=([NSString stringWithFormat:@"%d",sqlite3_column_int(localizer, 5)]),*nv2=([NSString stringWithFormat:@"%d",sqlite3_column_int(localizer, 6)]);
	NSString *problem=[NSString stringWithFormat:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)], sv1, sv2, ov1, ov2, sqlite3_column_int(localizer, 5), sqlite3_column_int(localizer, 6)];
	sqlite3_finalize(localizer);
	
	//load keywords.
	sqlite3_prepare_v2(dbo, [@"SELECT problem_keywords.keywords FROM problems, problem_keywords WHERE problems.id=:problemid AND problem_keywords.string_id=problems.string_id" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_int(localizer, 1, problemID);
	sqlite3_step(localizer);
	NSString *important=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)];
	sqlite3_finalize(localizer);
	NSMutableArray *keywords=[[NSMutableArray alloc] init];
	[keywords addObject:sv1];[keywords addObject:sv2];[keywords addObject:ov1];[keywords addObject:ov2];[keywords addObject:nv1];[keywords addObject:nv2];
	[keywords addObjectsFromArray:[important componentsSeparatedByString:@"@"]];

	localizer =NULL;
	
	//remove from view first
	[RINFindAct removeRINFindActView:mArray];
	//than make problem with keyword;
	mArray=[RINFindAct makeRINFindActView:[self view] Frame:CGRectMake(20, 250, 984, 350) String:problem Important:keywords];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch =[[event allTouches] anyObject];
	if(CGRectContainsPoint([mefindingDoInstruction frame], [touch locationInView:[self view]])) {
		NSError *err=nil;
		NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
		avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.finding.do.instruction.0.%d.m4a",langCode]] error:&err];
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