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

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	isGoodToContinue=NO;
	meComputingAskActivity=[[MEComputingAskViewController alloc] initWithNibName:@"MEComputingAskViewController" bundle:nil];
	
	[self setButton:MEButtonSay hidden:NO];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode],problemID=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] problemID];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
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
	
	sqlite3_prepare_v2(dbo, [@"SELECT problem_strings.string, problem_nouns.sv1, problem_nouns.sv2, problem_nouns.ov1, problem_nouns.ov2, problem_numbers.nv1, problem_numbers.nv2 FROM problems, problem_strings, problem_nouns, problem_numbers WHERE problems.id=:problemid AND problems.lang=:langcode AND problem_strings.id=problems.string_id AND problem_nouns.id=problems.noun_id AND problem_numbers.id=problems.number_id" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_int(localizer, 1, problemID);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	const char *sv1=(const char *)sqlite3_column_text(localizer, 1), *sv2=(const char *)sqlite3_column_text(localizer, 2), *ov1=(const char *)sqlite3_column_text(localizer, 3), *ov2=(const char *)sqlite3_column_text(localizer, 4);
	char emptstr[1]={0};
	NSString *problem =[NSString stringWithFormat:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)], sv1==NULL?emptstr:sv1, sv2==NULL?emptstr:sv2, ov1==NULL?emptstr:ov1, ov2==NULL?emptstr:ov2, sqlite3_column_int(localizer, 5), sqlite3_column_int(localizer, 6)];
	sqlite3_finalize(localizer);
	
	sqlite3_prepare_v2(dbo, [@"SELECT problem_numbers.nv1, problem_numbers.nv2, problem_numbers.type FROM problem_numbers, problems WHERE problems.id=:problemid AND problem_numbers.id=problems.number_id" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_int(localizer, 1, problemID);
	sqlite3_step(localizer);
	cnv[0]=sqlite3_column_int(localizer, 0);
	cnv[1]=sqlite3_column_int(localizer, 1);
	cnv[2]=sqlite3_column_int(localizer, 2);

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
		now = [now initWithString:key Front:prev Frame:CGRectMake(20, 110, 984, 190)];
		for(NSString *subkey in importantArray) {
			if([key hasPrefix:subkey]) {
				[now setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			}
		}
		[self.view addSubview:now];
		prev= now;
	}
	meComputingTool = [[RINCalculrator alloc] initWithFrame:meComputingTool.frame];
	[meComputingTool setViewController:self];
	[meComputingTool setNv1:cnv[0]];
	[meComputingTool setNv2:cnv[1]];
	[meComputingTool setCorrect:(cnv[2]==0?(cnv[0]+cnv[1]):(ABS(cnv[0]-cnv[1])))];
	[self.view addSubview:meComputingTool];
}

-(void)sayButtonAction:(id)sender {
	//
}

-(void)nextButtonAction:(id)sender {
	if(isGoodToContinue==NO) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToContinue:) name:MEAskActivityConfirmed object:nil];
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
			[self presentModalViewController:meComputingAskActivity animated:YES];
			[meComputingAskActivity yesButtonAction:nil];
		} else {
			[self presentModalViewController:meComputingAskActivity animated:YES];
			[meComputingAskActivity noButtonAction:nil];
		}
	} else if (ctype==1) {
		if(nv1==cnv1&&nv2==cnv2&&nv3==(nv1-nv2)&&nsn==1) {
			[self presentModalViewController:meComputingAskActivity animated:YES];
			[meComputingAskActivity yesButtonAction:nil];
		} else {
			[self presentModalViewController:meComputingAskActivity animated:YES];
			[meComputingAskActivity noButtonAction:nil];
		}
	} else {
		if(nv3==(nv1+nv2)&&nsn==0 && ((nv1==cnv1&&nv2==cnv2)||(nv1==cnv2&&nv2==cnv1))) {
			[self presentModalViewController:meComputingAskActivity animated:YES];
			[meComputingAskActivity yesButtonAction:nil];
		} else {
			[self presentModalViewController:meComputingAskActivity animated:YES];
			[meComputingAskActivity noButtonAction:nil];
		}
	}
}
-(IBAction)PressTutorialButton:(id)sender {
	[meComputingTool PressTutorialButton:sender event:nil];
}

@end
