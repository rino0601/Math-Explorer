//
//  MEDrawingTitleViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MEDrawingTitleViewController:MEPageTemplateViewController {
	@private
	IBOutlet UILabel *meDrawingTitle;
	AVAudioPlayer *avp;
}

@end