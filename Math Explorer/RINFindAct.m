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
@synthesize relateF,relateR;

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
+(NSMutableArray *)makeRINFindActView:(UIView *)view Frame:(CGRect)frame String:(NSString *)string Important:(NSArray *)important {
	//important has NSStrings
	NSMutableArray *mArray=[[NSMutableArray alloc] init];
	NSArray *container=[string componentsSeparatedByString:@" "];
	RINFindAct *prev=nil;
	for(NSString *key in container) {
		RINFindAct *now=[RINFindAct alloc];
		if(prev!=nil) {
			[prev setRear:now];
		}
		now = [now initWithString:key Front:prev Frame:frame];
		[view addSubview:now];
		prev= now;
		[mArray addObject:now];
	}
	container=nil;
	
	NSInteger importantlast=[important indexOfObject:[important lastObject]];
	NSInteger mArrayLast=[mArray indexOfObject:[mArray lastObject]];
	for (NSInteger i=0 ; i<=importantlast ; i++) {
		NSArray *compare=[(NSString *)[important objectAtIndex:i] componentsSeparatedByString:@" "];
		NSInteger compareLast=[compare indexOfObject:[compare lastObject]];
		for(NSInteger j=0 ; j<=mArrayLast-compareLast ; j++) {
			RINFindAct *temp=[mArray objectAtIndex:j];
			BOOL mark=YES;
			for(NSInteger k=0 ; k<=compareLast ; k++ ) {
				temp=[mArray objectAtIndex:j+k];
				mark=mark&&(![temp important])&&[[temp currentTitle] hasPrefix:[compare objectAtIndex:k]];
			} if(mark) {
				for (NSInteger k=0 ; k<=compareLast ; k++ ) {
					temp=[mArray objectAtIndex:j+k];
					[temp setRelateF:YES];
					[temp setImportant:YES];
					[temp setRelateR:YES];
				}
				temp=[mArray objectAtIndex:j];
				[temp setRelateF:NO];
				temp=[mArray objectAtIndex:j+compareLast];
				[temp setRelateR:NO];
			}
		}
	}
	return mArray;
}
+(void)removeRINFindActView:(NSMutableArray *)RINView {
	for (RINFindAct *key in RINView) {
		[key removeFromSuperview];
	}
	[RINView removeAllObjects];
	[RINFindAct removeFoundWord];
	[RINFindAct removeSentence];
}
@end