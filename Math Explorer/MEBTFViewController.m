//
//  MEBTFViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEBTFViewController.h"
#import "MEAppDelegate.h"
#import "MEReadingTitleViewController.h"
#import "MELangSelectViewController.h"

@implementation MEBTFViewController
@synthesize problemSelecter,problemMeter,BTFtitle,BTFcoment;

-(IBAction)selectProblem:(UISlider *)sender {
	NSUInteger langCode = [(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	if(langCode==1) {
		[problemMeter setText:[NSString stringWithFormat:@"Let's learn problem number %3.0f",[problemSelecter value]]];
	} else {
		[problemMeter setText:[NSString stringWithFormat:@"%3.0f번 문제를 풀어볼래요.",[problemSelecter value]]];
	}
}

-(void)viewDidLoad {
	[super viewDidLoad];
	
	[self setButton:MEButtonHome hidden:YES];
	[self setButton:MEButtonSay hidden:YES];

	NSUInteger langCode = [(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	NSUInteger problemID = [(MEAppDelegate *)[[UIApplication sharedApplication] delegate] problemID];
	problemID=(langCode==2?problemID-288:problemID);
	problemID+=12;
	if(problemID>288)
		problemID=1;
	[problemSelecter setValue:problemID];
	
	switch (langCode) {
		case 1:
			[BTFtitle setText:@"WELDONE!!!"];
			[BTFcoment setText:@"learn more?"];
			[problemMeter setText:[NSString stringWithFormat:@"Let's learn problem number %3.0f",[problemSelecter value]]];
			break;
		case 2:
			[BTFtitle setText:@"참 잘했어요!!!"];
			[BTFcoment setText:@"좀 더 해볼래요?"];
			[problemMeter setText:[NSString stringWithFormat:@"%3.0f번 문제를 풀어볼래요.",[problemSelecter value]]];
			break;
		default:
			NSLog(@"ERR BTF viewDidLoad");
			break;
	}
}

-(void)prevButtonAction:(id)sender {
	NSMutableArray *goingBack=[NSMutableArray arrayWithObject:[[MELangSelectViewController alloc] initWithNibName:@"MELangSelectViewController" bundle:nil]];
	[goingBack addObject:self];
	[[self navigationController] setViewControllers:goingBack animated:NO];
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void)nextButtonAction:(id)sender {
	NSUInteger langCode = [(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	NSUInteger next=[problemSelecter value];
	if(langCode==2)
		next+=288;
	[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] setProblemID:next];
	NSMutableArray *goingNext=[NSMutableArray arrayWithObject:[[MEReadingTitleViewController alloc] initWithNibName:@"MEReadingTitleViewController" bundle:nil]];
	[goingNext addObject:self];
	[[self navigationController] setViewControllers:goingNext animated:NO];
	[[self navigationController] popViewControllerAnimated:YES];
}


@end
