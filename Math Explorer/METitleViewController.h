//
//  METitleViewController.h
//  Math Explorer
//
//  Created by Hyun Hwang on 7/6/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface METitleViewController:MEPageTemplateViewController {
	@private
	IBOutlet UIButton *meTitle, *meSubtitle;
	AVAudioPlayer *playerSubtitle, *playerTitle;
}

-(IBAction)saySubtitle:(id)sender;
-(IBAction)sayTitle:(id)sender;


@end