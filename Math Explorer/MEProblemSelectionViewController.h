//
//  MEProblemSelectionViewController.h
//  Math Explorer
//
//  Created by Hyun Hwang on 7/31/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEAskModalTemplateViewController.h"


@interface MEProblemSelectionViewController:MEAskModalTemplateViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *picker;
	NSUInteger selectedProblemID;
}

-(IBAction)jumpToProblemID:(id)sender;

@end