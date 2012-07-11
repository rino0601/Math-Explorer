//
//  MEDrawingDoViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEDrawingDoViewController.h"
#import "CIHCanvasView.h"
#import "MEAppDelegate.h"
#import "MEDrawingAskViewController.h"
#import "MEComputingTitleViewController.h"


@implementation MEDrawingDoViewController

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	CIHCanvasView *canvas=[[CIHCanvasView alloc] initWithFrame:CGRectMake(20, 300, 984, 280)];
	[canvas setAlpha:0.5];
	[canvas changeColor:[UIColor blueColor]];
	[[self view] addSubview:canvas];
	
	
	isGoodToContinue=NO;
	meDrawingAskActivity=[[MEDrawingAskViewController alloc] initWithNibName:@"MEDrawingAskViewController" bundle:nil];
	[self setButton:MEButtonSay hidden:NO];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode],problemID = langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] problemID];
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
	const char *sv1=(const char *)sqlite3_column_text(localizer, 1), *sv2=(const char *)sqlite3_column_text(localizer, 2), *ov1=(const char *)sqlite3_column_text(localizer, 3), *ov2=(const char *)sqlite3_column_text(localizer, 4);
	char emptstr[1]={0};
	[meDrawingDoProblem setText:[NSString stringWithFormat:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)], sv1==NULL?emptstr:sv1, sv2==NULL?emptstr:sv2, ov1==NULL?emptstr:ov1, ov2==NULL?emptstr:ov2, sqlite3_column_int(localizer, 5), sqlite3_column_int(localizer, 6)]];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
}

-(void)sayButtonAction:(id)sender {
	//
}

-(void)nextButtonAction:(id)sender {
	if(isGoodToContinue==NO) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToContinue:) name:MEAskActivityConfirmed object:nil];
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

@end
