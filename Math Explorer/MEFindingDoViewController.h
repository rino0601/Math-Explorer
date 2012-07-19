//
//  MEFindingDoViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 9..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"
#import <AVFoundation/AVFoundation.h>

@class MEFindingAskViewController;

@interface MEFindingDoViewController:MEPageTemplateViewController {
	@private
	AVAudioPlayer *avp;
	BOOL isGoodToContinue;
	MEFindingAskViewController *meFindingAskActivity;
	IBOutlet UILabel *mefindingDoInstruction;
	NSMutableArray *mArray;
}

@end