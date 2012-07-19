//
//  RINFindAct.m
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 15..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "RINFindAct.h"

@implementation RINFindAct

@synthesize important;

static NSMutableArray *_foundWord;
static NSMutableArray *_sentence;

+(NSMutableArray *)foundWord {
	if(_foundWord==nil) {
		_foundWord=[[NSMutableArray alloc] init];
	}
	return _foundWord;
}
+(void)removeFoundWord {
	if(_foundWord==nil)
		return;
	[_foundWord removeAllObjects];
}
+(NSMutableArray *)sentence {
	if(_sentence==nil) {
		_sentence=[[NSMutableArray alloc] init];
	}
	return _sentence;
}
+(void)removeSentence {
	if(_sentence==nil)
		return;
	[_sentence removeAllObjects];
}
-(CGRect)arragementBysize:(CGSize)itSize {
	CGRect _front = [front frame];
	CGSize space =[@" " sizeWithFont:[UIFont boldSystemFontOfSize:48.0]];
	if (front==nil) {
		return CGRectMake(scope.origin.x, scope.origin.y, itSize.width, itSize.height);
	}
	if(_front.origin.x+_front.size.width+space.width+space.width+itSize.width>scope.origin.x+scope.size.width) { //Line add.
		return CGRectMake(scope.origin.x, _front.origin.y+_front.size.height+8, itSize.width, itSize.height);
	}
	return CGRectMake(_front.origin.x+_front.size.width+space.width, _front.origin.y, itSize.width, itSize.height);
}

-(id)initWithString:(NSString *)string Front:(RINFindAct *)_front Frame:(CGRect)frame {
	self=[RINFindAct buttonWithType:UIButtonTypeCustom];
	scope=frame;
	CGSize labelSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:48.0]];
	front=_front;
    [self setTitle:string forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
	[self setFrame:[self arragementBysize:labelSize]];
	[self setTitle:string forState:UIControlStateNormal];
	[[self titleLabel] setFont:[UIFont boldSystemFontOfSize:48.0]];
	[self setUserInteractionEnabled:YES];
	[self addTarget:self action:@selector(found:) forControlEvents:UIControlEventTouchUpInside];
	[[RINFindAct sentence] addObject:self];
	return self;
}

-(void)found:(id)sender {
	if([(UIButton *)sender currentTitleColor]==[UIColor redColor])
		return;
	if(!important)
		return ;
	NSString *word;
	if(relateR) {
		[rear found:rear];
	}else {
		word = [self _found:sender];
		[[RINFindAct foundWord] addObject:word];
	}
}
-(NSMutableString *)_found:(id)sender {
	RINFindAct *me = sender;
	NSMutableString *word = [NSMutableString stringWithString:@""];
	if(relateF) {
		[word appendString:[front _found:front]];
	}
	[word appendString:[NSString stringWithFormat:@" %@",[me currentTitle]]];
	[me setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	for(RINFindAct *key in [RINFindAct sentence]) {
		if([[key currentTitle] isEqualToString:[me currentTitle]]) {
			[key setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		} else {
			if([[key currentTitle] hasPrefix:[me currentTitle]]) {
				[key setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			}
			if ([[me currentTitle] hasPrefix:[key currentTitle]]) {
				[key setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			}
		}
	}
	return word;
}
-(void)setRear:(RINFindAct *)_rear {
	rear=_rear;
}

@end