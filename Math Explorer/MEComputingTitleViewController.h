//
//  MEComputingTitleViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MEComputingTitleViewController : MEPageTemplateViewController {
	@private
	IBOutlet UILabel *meComputingTitle;
	AVAudioPlayer *avp;
}

@end
