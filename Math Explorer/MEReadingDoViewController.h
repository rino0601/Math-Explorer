//
//  MEReadingDoViewController.h
//  Math Explorer
//
//  Created by Hyun Hwang on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"


@class MEReadingAskViewController;

@interface MEReadingDoViewController:MEPageTemplateViewController {
	@private
	MEReadingAskViewController *meReadingAskActivity;
	IBOutlet UILabel *meReadingDoInstruction;
}

@end