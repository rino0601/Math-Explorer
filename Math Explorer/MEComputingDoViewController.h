//
//  MEComputingDoViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"
#import "RINCalculrator.h"

@class MEComputingAskViewController;
@class RINCalculrator;

@protocol RINCalculratorDelegate;

@interface MEComputingDoViewController : MEPageTemplateViewController <RINCalculratorDelegate> {
	@private
	BOOL isGoodToContinue;
	MEComputingAskViewController *meComputingAskActivity;
	IBOutlet UILabel *meComputingDoInstruction;
	IBOutlet RINCalculrator *meComputingTool;
	int cnv[3];
}
-(void)submitUserAnswerWithValues:(NSArray *)values;
-(IBAction)PressTutorialButton:(id)sender;
@end
