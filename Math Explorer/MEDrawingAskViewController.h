//
//  MEDrawingAskViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEAskModalTemplateViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MEDrawingAskViewController : MEAskModalTemplateViewController {
	@private
	NSInteger next[10];
	NSString *string[10];
	NSUInteger current;
	IBOutlet UITextView *meDrawingAsk;
}

@end
