//
//  RINFindAct.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 15..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RINFindAct : UIButton {
@private
	RINFindAct *front, *rear;
	BOOL relateF,relateR;
	BOOL important;
	CGRect scope;
}
@property BOOL important;

+(NSMutableArray *)foundWord;
+(NSMutableArray *)sentence;
-(CGRect)arragementBysize:(CGSize)itSize;
-(id)initWithString:(NSString *)string Front:(RINFindAct *)_front Frame:(CGRect)frame;
-(void)found:(id)sender;
-(NSMutableString *)_found:(id)sender;

-(void)setRear:(RINFindAct *)_rear;

@end