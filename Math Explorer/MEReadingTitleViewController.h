//
//  MEReadingTitleViewController.h
//  Math Explorer
//
//  Created by Hyun Hwang on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface MEReadingTitleViewController:MEPageTemplateViewController {
	@private
	IBOutlet UIButton *meReadingTitle;
	AVAudioPlayer *playerTitle;
}

-(IBAction)sayTitle:(id)sender;

@end