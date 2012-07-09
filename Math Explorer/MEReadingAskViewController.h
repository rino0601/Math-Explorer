//
//  MEReadingAskViewController.h
//  Math Explorer
//
//  Created by Hyun Hwang on 7/8/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEAskModalTemplateViewController.h"


@interface MEReadingAskViewController:MEAskModalTemplateViewController {
	@private
	NSInteger next[8];
	NSString *string[8];
	IBOutlet UITextView *meReadingAsk;
}

@end