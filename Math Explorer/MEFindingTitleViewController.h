//
//  MEFindingTitleViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 9..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MEFindingTitleViewController:MEPageTemplateViewController{
	@private
	IBOutlet UILabel *meFindingTitle;
	AVAudioPlayer *avp;
}

@end