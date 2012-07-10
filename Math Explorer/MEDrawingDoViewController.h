//
//  MEDrawingDoViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"

@class MEDrawingAskViewController;

@interface MEDrawingDoViewController : MEPageTemplateViewController {
@private
	MEDrawingAskViewController *meDrawingAskActivity;
	IBOutlet UILabel *meDrawingDoInstruction;
}

@end
