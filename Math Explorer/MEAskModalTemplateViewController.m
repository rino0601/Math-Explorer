//
//  MEAskViewController.m
//  Math Explorer
//
//  Created by Hanjong Ko on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEAskModalTemplateViewController.h"
#import "MEAppDelegate.h"


NSString *const MEAskActivityConfirmed=@"Nothing interesting here.";

@implementation MEAskModalTemplateViewController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft);
}

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	noCount=0;
	
	// Background
	UIImageView *backgroundImage=[[UIImageView alloc] initWithFrame:CGRectMake(0-(1024-540)/2, 0-(768-620)/2, 1024, 768)];
	[backgroundImage setImage:[UIImage imageNamed:@"Background.png"]];
	[[self view] addSubview:backgroundImage];
	[[self view] sendSubviewToBack:backgroundImage];
	
	// Say button
	utilSay=[UIButton buttonWithType:UIButtonTypeCustom];
	[utilSay setFrame:CGRectMake(39, 472, 128, 128)];
	[utilSay setBackgroundImage:[UIImage imageNamed:@"UtilSay.png"] forState:UIControlStateNormal];
	[utilSay addTarget:self action:@selector(sayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[utilSay setHidden:YES];
	[[self view] addSubview:utilSay];
	
	// No button
	chkNo=[UIButton buttonWithType:UIButtonTypeCustom];
	[chkNo setFrame:CGRectMake(206, 472, 128, 128)];
	[[chkNo titleLabel] setFont:[UIFont boldSystemFontOfSize:48.0]];
	[chkNo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[chkNo addTarget:self action:@selector(noButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:chkNo];
	
	// Yes button
	chkYes=[UIButton buttonWithType:UIButtonTypeCustom];
	[chkYes setFrame:CGRectMake(373, 472, 128, 128)];
	[[chkYes titleLabel] setFont:[UIFont boldSystemFontOfSize:48.0]];
	[chkYes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[chkYes addTarget:self action:@selector(yesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:chkYes];
	
	// Approve button
	chkAprv=[UIButton buttonWithType:UIButtonTypeCustom];
	[chkAprv setFrame:CGRectMake(373, 472, 128, 128)];
	[chkAprv setBackgroundImage:[UIImage imageNamed:@"ChkAprv.png"] forState:UIControlStateNormal];
	[chkAprv addTarget:self action:@selector(approveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[chkAprv setHidden:YES];
	[[self view] addSubview:chkAprv];
	
	NSUInteger langCode=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] langCode];
	sqlite3 *dbo=[(MEAppDelegate *)[[UIApplication sharedApplication] delegate] dbo];
	sqlite3_stmt *localizer=NULL;
	
	sqlite3_prepare_v2(dbo, [@"SELECT value FROM general_strings WHERE key=:keystring AND lang=:langcode" UTF8String], -1, &localizer, NULL);
	sqlite3_bind_text(localizer, 1, [@"me.ask.button.no" UTF8String], -1, NULL);
	sqlite3_bind_int(localizer, 2, langCode);
	sqlite3_step(localizer);
	[chkNo setTitle:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)] forState:UIControlStateNormal];
	sqlite3_reset(localizer);
	
	sqlite3_bind_text(localizer, 1, [@"me.ask.button.yes" UTF8String], -1, NULL);
	sqlite3_step(localizer);
	[chkYes setTitle:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(localizer, 0)] forState:UIControlStateNormal];
	sqlite3_finalize(localizer);
	
	localizer=NULL;
}

-(void)sayButtonAction:(id)sender {
	@throw [NSException exceptionWithName:@"ButtonActionNotImplementedException" reason:@"Say button's action is not implemented yet." userInfo:nil];
}

-(void)noButtonAction:(id)sender {
	++noCount;
}

-(void)yesButtonAction:(id)sender {
	@throw [NSException exceptionWithName:@"ButtonActionNotImplementedException" reason:@"Yes button's action is not implemented yet." userInfo:nil];
}

-(void)approveButtonAction:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:MEAskActivityConfirmed object:self userInfo:nil];
	[[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

@end