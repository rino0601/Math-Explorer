//
//  MEComputingDoViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"
#import "RINCalculrator.h"
#import <AVFoundation/AVFoundation.h>

@class MEComputingAskViewController;
@class RINCalculrator;

@protocol RINCalculratorDelegate;

@interface MEComputingDoViewController : MEPageTemplateViewController <RINCalculratorDelegate> {
	@private
	AVAudioPlayer *avp;
	BOOL isGoodToContinue;
	MEComputingAskViewController *meComputingAskActivity;
	IBOutlet UILabel *meComputingDoInstruction;
	IBOutlet RINCalculrator *meComputingTool;
	int cnv[3];
	NSMutableArray *mArray;
}
-(void)submitUserAnswerWithValues:(NSArray *)values;
-(IBAction)PressTutorialButton:(id)sender;
@end
