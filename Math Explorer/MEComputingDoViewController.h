//
//  MEComputingDoViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"

@class MEComputingAskViewController;

@interface MEComputingDoViewController : MEPageTemplateViewController {
	@private
	MEComputingAskViewController *meComputingAskActivity;
	IBOutlet UILabel *meComputingDoInstruction;
}

@end
