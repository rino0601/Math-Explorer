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


@implementation MEFindingDoViewController

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	isGoodToContinue=NO;
	meFindingAskActivity=[[MEFindingAskViewController alloc] initWithNibName:@"MEFindingAskViewController" bundle:nil];
	
	// optional(or test) area
	
	[self setButton:MEButtonSay hidden:NO];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode],problemID=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] problemID];
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
		now = [now initWithString:key Front:prev];
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
	//
}

-(void)homeButtonAction:(id)sender {
	NSMutableArray *restoring=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] homeBackup];
	[restoring removeLastObject];
	[restoring addObject:self];
	[[self navigationController] setViewControllers:restoring animated:NO];
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void)nextButtonAction:(id)sender {
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

@implementation RINFindAct

@synthesize important;

static NSMutableArray *_foundWord;
static NSMutableArray *_sentence;

+(NSMutableArray *)foundWord {
	if(_foundWord==nil) {
		_foundWord=[[NSMutableArray alloc] init];
	}
	return _foundWord;
}
+(NSMutableArray *)sentence {
	if(_sentence==nil) {
		_sentence=[[NSMutableArray alloc] init];
	}
	return _sentence;
}
-(CGRect)arragementBysize:(CGSize)itSize {
	CGRect scope=CGRectMake(20, 250, 984, 350);
	CGRect _front = [front frame];
	CGSize space =[@" " sizeWithFont:[UIFont boldSystemFontOfSize:36.0]];
	if (front==nil) {
		return CGRectMake(20, 250, itSize.width, itSize.height);
	}
	if(_front.origin.x+_front.size.width+space.width+space.width+itSize.width>scope.origin.x+scope.size.width) { //Line add.
		return CGRectMake(scope.origin.x, _front.origin.y+_front.size.height+8, itSize.width, itSize.height);
	}
	return CGRectMake(_front.origin.x+_front.size.width+space.width, _front.origin.y, itSize.width, itSize.height);
}

-(id)initWithString:(NSString *)string Front:(RINFindAct *)_front{
	CGSize labelSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:36.0]];
	
	self=[RINFindAct buttonWithType:UIButtonTypeCustom];
	front=_front;
    [self setTitle:string forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
	[self setFrame:[self arragementBysize:labelSize]];
	[self setTitle:string forState:UIControlStateNormal];
	[[self titleLabel] setFont:[UIFont boldSystemFontOfSize:36.0]];
	[self setUserInteractionEnabled:YES];
	[self addTarget:self action:@selector(found:) forControlEvents:UIControlEventTouchUpInside];
	[[RINFindAct sentence] addObject:self];
	return self;
}

-(void)found:(id)sender {
	if([(UIButton *)sender currentTitleColor]==[UIColor redColor])
		return;
	if(!important)
		return ;
	NSString *word;
	if(relateR) {
		 [rear found:rear];
	}else {
		word = [self _found:sender];
		[[RINFindAct foundWord] addObject:word];
//		NSLog(@"%@",[RINFindAct foundWord]);
	}
}
-(NSMutableString *)_found:(id)sender {
	RINFindAct *me = sender;
	NSMutableString *word = [NSMutableString stringWithString:@""];
	if(relateF) {
		[word appendString:[front _found:front]];
	}
	[word appendString:[NSString stringWithFormat:@" %@",[me currentTitle]]];
	[me setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	for(RINFindAct *key in [RINFindAct sentence]) {
		if([[key currentTitle] isEqualToString:[me currentTitle]]) {
			[key setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		} else {
			if([[key currentTitle] hasPrefix:[me currentTitle]]) {
				[key setTitleColor:[UIColor redColor] forState:UIControlStateNormal];	
			}
			if ([[me currentTitle] hasPrefix:[key currentTitle]]) {
				[key setTitleColor:[UIColor redColor] forState:UIControlStateNormal];	
			}
		}
	}
	return word;
}
-(void)setRear:(RINFindAct *)_rear {
	rear=_rear;
}

@end