//
//  MELearningGoalViewController.h
//  Math Explorer
//
//  Created by Hyun Hwang on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface MELearningGoalViewController:MEPageTemplateViewController {
	@private
	AVAudioPlayer *avp;
	IBOutlet UILabel *meLearningGoalTitle;
	IBOutlet UIWebView *meLearningGoalDetail;
}

@end