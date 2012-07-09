//
//  MEFindingAskViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 9..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEAskModalTemplateViewController.h"

@interface MEFindingAskViewController : MEAskModalTemplateViewController {
	@private
	NSInteger next[10];
	NSString *string[10];
	NSUInteger current;
	IBOutlet UITextView *meFindingAsk;
}

@end
