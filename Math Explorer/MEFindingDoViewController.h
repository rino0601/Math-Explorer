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
	BOOL isGoodToContinue;
	MEFindingAskViewController *meFindingAskActivity;
	IBOutlet UILabel *mefindingDoInstruction;
	
}

@end

@interface RINFindAct : UIButton {
	@private
	RINFindAct *front, *rear;
	BOOL relateF,relateR;
	BOOL important;
}
@property BOOL important;

+(NSMutableArray *)foundWord;
+(NSMutableArray *)sentence;
-(CGRect)arragementBysize:(CGSize)itSize;
-(id)initWithString:(NSString *)string Front:(RINFindAct *)_front;
-(void)found:(id)sender;
-(NSMutableString *)_found:(id)sender;

-(void)setRear:(RINFindAct *)_rear;

@end