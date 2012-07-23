//
//  MEComputingDoViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEComputingDoViewController.h"
#import "MEAppDelegate.h"
#import "MEComputingAskViewController.h"
#import "MEBTFViewController.h"
#import "RINFindAct.h"


@implementation MEComputingDoViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	isGoodToContinue=NO;
	meComputingAskActivity=[[MEComputingAskViewController alloc] initWithNibName:@"MEComputingAskViewController" bundle:nil];
	
	[self setButton:MEButtonSay hidden:NO];
	
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode],problemID=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] problemID];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langcode" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.computing.do.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[self setTitle:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.computing.do.instruction" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	[meComputingDoInstruction setText:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
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
	
	//load number set to use math problem.
	sqlite3_prepare_v2(dbo, [@"SELECT problem_numbers.nv1, problem_numbers.nv2, problem_numbers.type FROM problem_numbers, problems WHERE problems.id=:problemid AND problem_numbers.id=problems.number_id" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_int(localizer, 1, problemID);
	sqlite3_step(localizer);
	cnv[0]=sqlite3_column_int(localizer, 0);
	cnv[1]=sqlite3_column_int(localizer, 1);
	cnv[2]=sqlite3_column_int(localizer, 2);
	sqlite3_finalize(localizer);
	
	localizer=NULL;
	
	mArray=[RINFindAct makeRINFindActView:[self view] Frame:CGRectMake(20, 110, 984, 190) String:problem Important:keywords];
	for (RINFindAct *comp in mArray) {
		if([comp important]) {
			[comp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[comp setImportant:NO];
		}
	}
	
	meComputingTool = [[RINCalculrator alloc] initWithFrame:meComputingTool.frame];
	[meComputingTool setViewController:self];
	[meComputingTool setNv1:cnv[0]];
	[meComputingTool setNv2:cnv[1]];
	[meComputingTool setCorrect:(cnv[2]==0?(cnv[0]+cnv[1]):(ABS(cnv[0]-cnv[1])))];
	[self.view addSubview:meComputingTool];
	
	[calExamples setText:(langCode==1?@"examples":@"예제들(눌러보세요)")];
	
	UITapGestureRecognizer* tapRecon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationBarTap:)];
    tapRecon.numberOfTapsRequired = 1;
	[[self.navigationController.navigationBar.subviews objectAtIndex:0] setUserInteractionEnabled:YES];
    [[self.navigationController.navigationBar.subviews objectAtIndex:0] addGestureRecognizer:tapRecon];
}

-(void)navigationBarTap:(UIGestureRecognizer *)recognizer {
	NSError *err=nil;
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.computing.do.title.0.%d.m4a",langCode]] error:&err];
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
	if(isGoodToContinue==NO) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToContinue:) name:MEAskActivityConfirmed object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(problemChange:) name:MEAskActivityDismissed object:nil];
		[meComputingAskActivity setModalPresentationStyle:UIModalPresentationFormSheet];
		
		[self presentModalViewController:meComputingAskActivity animated:YES];
	} else {
		[[self navigationController] pushViewController:[[MEBTFViewController alloc] initWithNibName:@"MEBTFViewController" bundle:nil] animated:YES];
	}
}

-(void)readyToContinue:(NSNotification *)notif {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MEAskActivityConfirmed object:nil];
	isGoodToContinue=YES;
}
-(void)problemChange:(NSNotification *)notif {
	//remove notification observer.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MEAskActivityDismissed object:nil];
	
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
	mArray=[RINFindAct makeRINFindActView:[self view] Frame:CGRectMake(20, 110, 984, 190) String:problem Important:keywords];
	for (RINFindAct *comp in mArray) {
		if([comp important]) {
			[comp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			[comp setImportant:NO];
		}
	}
	sqlite3_prepare_v2(dbo, [@"SELECT problem_numbers.nv1, problem_numbers.nv2, problem_numbers.type FROM problem_numbers, problems WHERE problems.id=:problemid AND problem_numbers.id=problems.number_id" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_int(localizer, 1, problemID);
	sqlite3_step(localizer);
	cnv[0]=sqlite3_column_int(localizer, 0);
	cnv[1]=sqlite3_column_int(localizer, 1);
	cnv[2]=sqlite3_column_int(localizer, 2);
	sqlite3_finalize(localizer);
	localizer=NULL;
	
	[meComputingTool setNv1:cnv[0]];
	[meComputingTool setNv2:cnv[1]];
	[meComputingTool setCorrect:(cnv[2]==0?(cnv[0]+cnv[1]):(ABS(cnv[0]-cnv[1])))];
	
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch =[[event allTouches] anyObject];
	if(CGRectContainsPoint([meComputingDoInstruction frame], [touch locationInView:[self view]])) {
		NSError *err=nil;
		NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
		avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.computing.do.instruction.0.%d.m4a",langCode]] error:&err];
		[avp setVolume:1.0f];
		[avp prepareToPlay];
		
		if([avp isPlaying]==NO) {
			[avp setCurrentTime:0.0];
			[avp play];
		} else
			[avp stop];
	}
}

-(void)submitUserAnswerWithValues:(NSArray *)values {
	int cnv1=cnv[0];
	int cnv2=cnv[1];
	int ctype=cnv[2];
	NSNumber *temp;
	int nv1,nv2,nv3,nsn;
	temp = [values objectAtIndex:0];
	nv1 = [temp intValue];
	temp = [values objectAtIndex:1];
	nv2 = [temp intValue];
	temp = [values objectAtIndex:2];
	nv3 = [temp intValue];
	temp = [values objectAtIndex:3];
	nsn = [temp intValue];
	if (ctype==2) {
		if(nv1==cnv2&&nv2==cnv1&&nv3==(nv2-nv1)&&nsn==1) {
			[meComputingAskActivity setAnswer:[NSString stringWithFormat:@"O : %d-%d=%d",nv2,nv1,nv3]];
		} else {
			[meComputingAskActivity setAnswer:[NSString stringWithFormat:@"X : %d-%d=%d",nv2,nv1,nv3]];
		}
	} else if (ctype==1) {
		if(nv1==cnv1&&nv2==cnv2&&nv3==(nv1-nv2)&&nsn==1) {
			[meComputingAskActivity setAnswer:[NSString stringWithFormat:@"O : %d-%d=%d",nv1,nv2,nv3]];
		} else {
			[meComputingAskActivity setAnswer:[NSString stringWithFormat:@"X : %d-%d=%d",nv1,nv2,nv3]];
		}
	} else {
		if(nv3==(nv1+nv2)&&nsn==0 && ((nv1==cnv1&&nv2==cnv2)||(nv1==cnv2&&nv2==cnv1))) {
			[meComputingAskActivity setAnswer:[NSString stringWithFormat:@"O : %d+%d=%d",nv1,nv2,nv3]];
		} else {
			[meComputingAskActivity setAnswer:[NSString stringWithFormat:@"X : %d+%d=%d",nv1,nv2,nv3]];
		}
	}
}
-(IBAction)PressTutorialButton:(id)sender {
	[meComputingTool PressTutorialButton:sender event:nil];
}

@end
