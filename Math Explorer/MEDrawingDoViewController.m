//
//  MEDrawingDoViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEDrawingDoViewController.h"
#import "CIHCanvasView.h"
#import "CIHDraggableImageView.h"
#import "MEAppDelegate.h"
#import "MEDrawingAskViewController.h"
#import "MEComputingTitleViewController.h"
#import "RINFindAct.h"


@implementation MEDrawingDoViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	canvas=[[CIHCanvasView alloc] initWithFrame:CGRectMake(20, 300, 984, 280)];
	[canvas setAlpha:0.5];
	[canvas changeColor:[UIColor blueColor]];
	[[self view] addSubview:canvas];
	
	
	isGoodToContinue=NO;
	meDrawingAskActivity=[[MEDrawingAskViewController alloc] initWithNibName:@"MEDrawingAskViewController" bundle:nil];

	UIButton *utilEraser=[UIButton buttonWithType:UIButtonTypeCustom];
	[utilEraser setFrame:CGRectMake(332, 600, 128, 128)];
	[utilEraser setTitle:@"지우개" forState:UIControlStateNormal];//@
	[utilEraser addTarget:self action:@selector(clearSketchView:) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:utilEraser];

	CIHDraggableImageView *item = [[CIHDraggableImageView alloc] initWithFrame:CGRectMake(196, 600, 128, 128)];
	[item setImage:[UIImage imageNamed:@"apple.png"]];
	[item setDelegate:self];
	[item setUserInteractionEnabled:YES];
	[[self view] addSubview:item];

	
	[self setButton:MEButtonSay hidden:NO];
	
	NSError *err=nil;
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode],problemID=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] problemID];
	
	avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.problem.%d.%03d.m4a", langCode, problemID%288]] error:&err];
	[avp setVolume:1.0f];
	[avp prepareToPlay];
	
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langcode" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.drawing.do.title" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[self setTitle:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.drawing.do.instruction" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	[meDrawingDoInstruction setText:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)]];
	sqlite3_finalize(localizer);
	
	sqlite3_prepare_v2(dbo, [@"SELECT problem_strings.string, problem_nouns.sv1, problem_nouns.sv2, problem_nouns.ov1, problem_nouns.ov2, problem_numbers.nv1, problem_numbers.nv2 FROM problems, problem_strings, problem_nouns, problem_numbers WHERE problems.id=:problemid AND problems.lang=:langcode AND problem_strings.id=problems.string_id AND problem_nouns.id=problems.noun_id AND problem_numbers.id=problems.number_id" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_int(localizer, 1, problemID);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	const char *_sv1=(const char *)sqlite3_column_text(localizer, 1), *_sv2=(const char *)sqlite3_column_text(localizer, 2), *_ov1=(const char *)sqlite3_column_text(localizer, 3), *_ov2=(const char *)sqlite3_column_text(localizer, 4);
	NSString *sv1=(_sv1==NULL?[NSString string]:[NSString stringWithUTF8String:_sv1]),*sv2=(_sv2==NULL?[NSString string]:[NSString stringWithUTF8String:_sv2]),*ov1=(_ov1==NULL?[NSString string]:[NSString stringWithUTF8String:_ov1]),*ov2=(_ov2==NULL?[NSString string]:[NSString stringWithUTF8String:_ov2]);
	NSString *problem=[NSString stringWithFormat:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)], sv1, sv2, ov1, ov2, sqlite3_column_int(localizer, 5), sqlite3_column_int(localizer, 6)];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
	
	NSArray *container=[problem componentsSeparatedByString:@" "];
	NSArray *importantArray=[NSArray arrayWithObjects:@"Becky",@"apples",nil];
	mArray = [[NSMutableArray alloc] init];
	
	RINFindAct *prev=nil;
	for(NSString *key in container) {
		RINFindAct *now=[RINFindAct alloc];
		if(prev!=nil) {
			[prev setRear:now];
		}
		now = [now initWithString:key Front:prev Frame:CGRectMake(20, 110, 984, 190)];
		for(NSString *subkey in importantArray) {
			if([key hasPrefix:subkey]) {
				[now setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			}
		}
		[self.view addSubview:now];
		prev= now;
		[mArray addObject:now];
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
	if(isGoodToContinue==NO) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToContinue:) name:MEAskActivityConfirmed object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(problemChange:) name:MEAskActivityDismissed object:nil];
		[meDrawingAskActivity setModalPresentationStyle:UIModalPresentationFormSheet];
		
		[self presentModalViewController:meDrawingAskActivity animated:YES];
	} else {
		[[self navigationController] setViewControllers:[NSArray arrayWithObject:[[MEComputingTitleViewController alloc] initWithNibName:@"MEComputingTitleViewController" bundle:nil]] animated:YES];
	}
}

-(void)readyToContinue:(NSNotification *)notif {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MEAskActivityConfirmed object:nil];
	isGoodToContinue=YES;
}

-(void)problemChange:(NSNotification *)notif {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MEAskActivityDismissed object:nil];
	static NSUInteger stepProblemId=0;
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode], problemID=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] problemID];
	if(stepProblemId==0) {
		stepProblemId=problemID;
	}
	stepProblemId+=4;
	if(stepProblemId>problemID+11){
		stepProblemId-=11;
		if(stepProblemId>problemID+11)
			stepProblemId=problemID;
	}
	NSError *err=nil;
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	avp=[[AVAudioPlayer alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"me.problem.%d.%03d.m4a", langCode, stepProblemId%288]] error:&err];
	[avp setVolume:1.0f];
	[avp prepareToPlay];
	
	sqlite3_prepare_v2(dbo, [@"SELECT problem_strings.string, problem_nouns.sv1, problem_nouns.sv2, problem_nouns.ov1, problem_nouns.ov2, problem_numbers.nv1, problem_numbers.nv2 FROM problems, problem_strings, problem_nouns, problem_numbers WHERE problems.id=:problemid AND problems.lang=:langcode AND problem_strings.id=problems.string_id AND problem_nouns.id=problems.noun_id AND problem_numbers.id=problems.number_id" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_int(localizer, 1, stepProblemId);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	const char *_sv1=(const char *)sqlite3_column_text(localizer, 1), *_sv2=(const char *)sqlite3_column_text(localizer, 2), *_ov1=(const char *)sqlite3_column_text(localizer, 3), *_ov2=(const char *)sqlite3_column_text(localizer, 4);
	NSString *sv1=(_sv1==NULL?[NSString string]:[NSString stringWithUTF8String:_sv1]),*sv2=(_sv2==NULL?[NSString string]:[NSString stringWithUTF8String:_sv2]),*ov1=(_ov1==NULL?[NSString string]:[NSString stringWithUTF8String:_ov1]),*ov2=(_ov2==NULL?[NSString string]:[NSString stringWithUTF8String:_ov2]);
	NSString *problem=[NSString stringWithFormat:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)], sv1, sv2, ov1, ov2, sqlite3_column_int(localizer, 5), sqlite3_column_int(localizer, 6)];
	sqlite3_finalize(localizer);
	
	NSArray *container=[problem componentsSeparatedByString:@" "];
	NSArray *importantArray=[NSArray arrayWithObjects:@"Becky",@"apples",nil];
	
	for (RINFindAct *key in mArray) {
		[key removeFromSuperview];
	}
	[mArray removeAllObjects];
	
	RINFindAct *prev=nil;
	for(NSString *key in container) {
		RINFindAct *now=[RINFindAct alloc];
		if(prev!=nil) {
			[prev setRear:now];
		}
		now = [now initWithString:key Front:prev Frame:CGRectMake(20, 110, 984, 190)];
		for(NSString *subkey in importantArray) {
			if([key hasPrefix:subkey]) {
				[now setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			}
		}
		[self.view addSubview:now];
		prev= now;
		[mArray addObject:now];
	}
	
}

-(void)clearSketchView:(id)sender {
	[canvas clearView];
}
-(IBAction)lineColorChanged:(id)sender {
	switch([sender selectedSegmentIndex]) {
		case 0:
		default:
			[canvas changeColor:[UIColor blackColor]];
			break;
		case 1:
			[canvas changeColor:[UIColor redColor]];
			break;
		case 2:
			[canvas changeColor:[UIColor blueColor]];
			break;
	}
}
-(IBAction)lineWidthChanged:(id)sender {
	switch([sender selectedSegmentIndex]) {
		case 0:
		default:
			[canvas changeWidth:LINE_THICKNESS_THICK];
			break;
		case 1:
			[canvas changeWidth:LINE_THICKNESS_NORMAL];
			break;
		case 2:
			[canvas changeWidth:LINE_THICKNESS_THIN];
			break;
	}
}
-(void)draggableImageView:(CIHDraggableImageView *)view dragFinishedOnKeyWindowAt:(CGPoint)groundZero {
	[canvas stampImage:[view image] at:groundZero withSize:[view bounds].size];
}
-(UIView *)getSketchFrame {
	return canvas;
}


@end
