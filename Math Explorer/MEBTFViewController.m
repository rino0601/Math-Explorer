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

@synthesize BTFtitle;


-(void)viewDidLoad {
	[super viewDidLoad];
	
	[self setButton:MEButtonHome hidden:YES];
	[self setButton:MEButtonSay hidden:YES];
	[self setButton:MEButtonPrev hidden:YES];

	NSUInteger langCode = [(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	NSUInteger problemID = [(MEAppDelegate *)[[UIApplication sharedApplication] delegate] problemID];
	problemID=((problemID-1)%288)+1;
	
	if([(MEAppDelegate *)[[UIApplication sharedApplication] delegate] GONEXT]== YES ) {
		if(problemID%4==0)
			problemID=problemID-((problemID-1)%12)+12;
		else
			problemID+=1;
	} else {
		if(problemID%12==0)
			problemID+=1;
		else {
			NSUInteger asdf=(problemID-1)%12;
			if(asdf>=8 && asdf<=10)
				problemID-=7;
			else
				problemID+=4;
		}
	}
//	problemID+=12;
	if(problemID>288)
		problemID=1;
	
	if(langCode==2)
		problemID+=288;
	
	[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] setProblemID:problemID];
	
	[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] setGONEXT:NO];
	
	switch (langCode) {
		case 1:
			[BTFtitle setText:@"WELLDONE!!!"];
			break;
		case 2:
			[BTFtitle setText:@"참 잘했어요!!!"];
			break;
		default:
			NSLog(@"ERR BTF viewDidLoad");
			break;
	}
}

-(void)nextButtonAction:(id)sender {
	NSMutableArray *goingNext=[NSMutableArray arrayWithObject:[[MEReadingTitleViewController alloc] initWithNibName:@"MEReadingTitleViewController" bundle:nil]];
	[goingNext addObject:self];
	[[self navigationController] setViewControllers:goingNext animated:NO];
	[[self navigationController] popViewControllerAnimated:YES];
}


@end
