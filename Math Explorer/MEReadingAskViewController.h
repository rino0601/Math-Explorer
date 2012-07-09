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
	IBOutlet UITextView *meReadingAsk;
	NSString *string[8];
	int next[8];
	int current;
}

@end