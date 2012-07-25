//
//  MEComputingAskViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEAskModalTemplateViewController.h"

@interface MEComputingAskViewController : MEAskModalTemplateViewController {
	@private
	NSInteger next[11];
	NSString *string[11];
	NSUInteger current;
	IBOutlet UITextView *meComputingAsk;
}
-(void)setAnswer:(NSString *)ans correct:(NSString *)correct;
@end
