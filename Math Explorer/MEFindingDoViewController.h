//
//  MEFindingDoViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 9..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"


@class MEFindingAskViewController;

@interface MEFindingDoViewController:MEPageTemplateViewController {
	@private
	MEFindingAskViewController *meFindingAskActivity;
	IBOutlet UILabel *meReadingDoInstruction;
}

@end