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

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	[self setButton:MEButtonHome hidden:YES];
	[self setButton:MEButtonSay hidden:YES];
	
}

-(void)prevButtonAction:(id)sender {
	NSMutableArray *goingBack=[NSMutableArray arrayWithObject:[[MELangSelectViewController alloc] initWithNibName:@"MELangSelectViewController" bundle:nil]];
	[goingBack addObject:self];
	[[self navigationController] setViewControllers:goingBack animated:NO];
	[[self navigationController] popViewControllerAnimated:YES];
}

-(void)nextButtonAction:(id)sender {
	NSUInteger old = [(MEAppDelegate *)[[UIApplication sharedApplication] delegate] problemID];
	[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] setProblemID:old+1];
	
	NSMutableArray *goingNext=[NSMutableArray arrayWithObject:[[MEReadingTitleViewController alloc] initWithNibName:@"MEReadingTitleViewController" bundle:nil]];
	[goingNext addObject:self];
	[[self navigationController] setViewControllers:goingNext animated:NO];
	[[self navigationController] popViewControllerAnimated:YES];
}


@end
