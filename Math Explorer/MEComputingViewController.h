//
//  MEComputingViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEAskModalTemplateViewController.h"

@interface MEComputingViewController : MEAskModalTemplateViewController {
	@private
	NSInteger next[10];
	NSString *string[10];
	NSUInteger current;
	IBOutlet UITextView *meComputingAsk;
}

@end
