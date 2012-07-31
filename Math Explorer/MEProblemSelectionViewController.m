//
//  MEProblemSelectionViewController.m
//  Math Explorer
//
//  Created by Hyun Hwang on 7/31/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEProblemSelectionViewController.h"
#import "MEAppDelegate.h"


@implementation MEProblemSelectionViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	
	MEAppDelegate *d=(MEAppDelegate *)[[UIApplication sharedApplication] delegate];
	selectedProblemID=(([d problemID]-1)%288)+1;
	[picker selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedProblemID-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
	
	[chkNo setHidden:YES];
	[chkYes setHidden:YES];
	[chkAprv setHidden:YES];
	[utilSay setHidden:YES];
}

-(IBAction)jumpToProblemID:(id)sender {
	MEAppDelegate *d=(MEAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[d setProblemID:selectedProblemID];
	
	if([d langCode]==2)
		[d setProblemID:[d problemID]+288];
	
	[[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifierString=@"ProblemSelector";
	
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierString];
	if(cell==nil)
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
	[[cell textLabel] setText:[NSString stringWithFormat:@"Problem %d", [indexPath row]+1]];
	
	return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 288;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	selectedProblemID=[indexPath row]+1;
}

@end