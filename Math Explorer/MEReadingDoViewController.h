//
//  MEReadingDoViewController.h
//  Math Explorer
//
//  Created by Hyun Hwang on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"
#import <AVFoundation/AVFoundation.h>


@class MEReadingAskViewController;

@interface MEReadingDoViewController:MEPageTemplateViewController {
	@private
	AVAudioPlayer *playerProblem, *playerTitle;
	BOOL isGoodToContinue;
	MEReadingAskViewController *meReadingAskActivity;
	IBOutlet UIButton *meReadingDoInstruction;
	IBOutlet UITextView *meReadingDoProblem;
}

-(IBAction)sayTitle:(id)sender;

@end