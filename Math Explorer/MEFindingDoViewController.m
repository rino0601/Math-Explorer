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
//#import "next View controller"


@implementation MEFindingDoViewController

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	meFindingAskActivity=[[MEFindingAskViewController alloc] initWithNibName:@"MEFindingAskViewController" bundle:nil];
	
	// optional(or test) area
	NSString *problem = @"Backy has five apples. Backy gives five apples to Criss. How many apple does Backy have all together?";
	NSArray *container=[problem componentsSeparatedByString:@" "];
	NSArray *importantArray=[NSArray arrayWithObject:@"Backy"];
	
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
	
	[self setButton:MEButtonSay hidden:NO];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_finalize(localizer);
	
	localizer=NULL;
	
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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readyToContinue:) name:MEAskActivityConfirmed object:nil];
	[meFindingAskActivity setModalPresentationStyle:UIModalPresentationFormSheet];
	
	[self presentModalViewController:meFindingAskActivity animated:YES];
}

-(void)readyToContinue:(NSNotification *)notif {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MEAskActivityConfirmed object:nil];
	//[[self navigationController] setViewControllers:[NSArray arrayWithObject:[[MEFindingTitleViewController alloc] initWithNibName:@"MEFindingTitleViewController" bundle:nil]] animated:YES];
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
		}
	}
	return word;
}
-(void)setRear:(RINFindAct *)_rear {
	rear=_rear;
}

@end