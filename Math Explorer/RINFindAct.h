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
	BOOL important;
	CGRect scope;
}
@property BOOL important;
@property BOOL relateF,relateR;


+(NSMutableArray *)foundWord;
+(NSMutableArray *)sentence;
+(NSMutableArray *)makeRINFindActView:(UIView *)view Frame:(CGRect)frame String:(NSString *)string Important:(NSArray *)important;
+(void)removeRINFindActView:(NSMutableArray *)RINView;
-(id)initWithString:(NSString *)string Front:(RINFindAct *)_front Frame:(CGRect)frame;
-(void)setRear:(RINFindAct *)_rear;

+(void)removeFoundWord;
+(void)removeSentence;
-(CGRect)arragementBysize:(CGSize)itSize;
-(void)found:(id)sender;
-(NSMutableString *)_found:(id)sender;




@end