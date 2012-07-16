//
//  RINCalculrator.m
//  RINCalculratorModule
//
//  Created by rino0601 on 12. 4. 11..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "RINCalculrator.h"

@implementation RINCalculrator
@synthesize nv1,nv2,correct;
@synthesize viewController;

//for initWithFrame
- (UIButton *)addButton:(NSString *)title parrentBound:(CGRect)bound Tag:(NSInteger)idTag {
	UIImage *NmImage= [UIImage imageNamed:@"backborddark.png"];
	UIImage *HgImage = [UIImage imageNamed:@"backbord.png"];
	CGRect bFrame = CGRectMake(bound.origin.x, bound.origin.y, bound.size.width, bound.size.height);
	
	UIButton *customButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	customButton.frame=bFrame;
	customButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	customButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[customButton setTitle:title forState: UIControlStateNormal];
	[[customButton titleLabel] setFont:[UIFont boldSystemFontOfSize:48.0]];
	[[customButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
	[customButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
	[customButton setBackgroundImage:NmImage forState: UIControlStateNormal];
	[customButton setBackgroundImage:HgImage forState: UIControlStateHighlighted];
	customButton.backgroundColor = [UIColor clearColor];
	[customButton setTag:idTag];
	[customButton setUserInteractionEnabled:YES];
	return customButton;
}

//for each button
- (void) PressNumberKeypad:(id)sender event:(UIEvent *)e {
	//tag 06,07,
	// 12,13,14,
	// 19,20,21
	//ans 23
	UIButton *SEND = (UIButton *)sender;
	NSString *CTNr;
	if([[(UIButton *)[self viewWithTag:19] titleLabel].text isEqualToString:@"="]){
		if([[(UIButton *)[self viewWithTag:20] titleLabel].text isEqualToString:@" "]) {
			CTNr=[(UIButton *)[self viewWithTag:21] currentTitle];
			[(UIButton *)[self viewWithTag:20] setTitle:CTNr forState:UIControlStateNormal];
			CTNr=[SEND currentTitle];
			[(UIButton *)[self viewWithTag:21] setTitle:CTNr forState:UIControlStateNormal];
		} else {
			return ;
		}
	} else {
		if([[(UIButton *)[self viewWithTag:12] titleLabel].text isEqualToString:@" "]){
			if([[(UIButton *)[self viewWithTag:6] titleLabel].text isEqualToString:@" "]){
				CTNr=[(UIButton *)[self viewWithTag:7] currentTitle];
				[(UIButton *)[self viewWithTag:6] setTitle:CTNr forState:UIControlStateNormal];
				CTNr=[SEND currentTitle];
				[(UIButton *)[self viewWithTag:7] setTitle:CTNr forState:UIControlStateNormal];
			}else {
				return ;
			}
		}else {
			if ([[(UIButton *)[self viewWithTag:13] titleLabel].text isEqualToString:@" "]) {
				CTNr=[(UIButton *)[self viewWithTag:14] currentTitle];
				[(UIButton *)[self viewWithTag:13] setTitle:CTNr forState:UIControlStateNormal];
				CTNr=[SEND currentTitle];
				[(UIButton *)[self viewWithTag:14] setTitle:CTNr forState:UIControlStateNormal];
			}else {
				return ;
			}
		}
	}
}
- (void) PressClearButton:(id)sender event:(UIEvent *)e {
	//UIButton *SEND = (UIButton *)sender;
	// tag 6,7,12,13,14,19,20,21
	[(UIButton *)[self viewWithTag:6] setTitle:@" " forState:UIControlStateNormal];
	[(UIButton *)[self viewWithTag:7] setTitle:@" " forState:UIControlStateNormal];
	[(UIButton *)[self viewWithTag:12] setTitle:@" " forState:UIControlStateNormal];
	[(UIButton *)[self viewWithTag:13] setTitle:@" " forState:UIControlStateNormal];
	[(UIButton *)[self viewWithTag:14] setTitle:@" " forState:UIControlStateNormal];
	[(UIButton *)[self viewWithTag:19] setTitle:@" " forState:UIControlStateNormal];
	[(UIButton *)[self viewWithTag:20] setTitle:@" " forState:UIControlStateNormal];
	[(UIButton *)[self viewWithTag:21] setTitle:@" " forState:UIControlStateNormal];
	[(UIButton *)[self viewWithTag:12] setEnabled:NO];
	[(UIButton *)[self viewWithTag:19] setEnabled:NO];
}
- (void) PressSignButton:(id)sender event:(UIEvent *)e {
	UIButton *SEND = (UIButton *)sender;
	NSString *Sign;
	Sign=[SEND currentTitle];
	[(UIButton *)[self viewWithTag:12] setTitle:Sign forState:UIControlStateNormal];
}
- (void) PressSubmitButton:(id)sender event:(UIEvent *)e {
	UIButton *nv11,*nv12,*nv21,*nv22;
	UIButton *na1,*na2;
	
	nv11=(UIButton *)[self viewWithTag:6];
	nv12=(UIButton *)[self viewWithTag:7];
	nv21=(UIButton *)[self viewWithTag:13];
	nv22=(UIButton *)[self viewWithTag:14];
	na1=(UIButton *)[self viewWithTag:20];
	na2=(UIButton *)[self viewWithTag:21];

	
	NSNumber *ng1=[[NSNumber alloc] initWithInt:[[nv11 currentTitle] intValue]*10+[[nv12 currentTitle] intValue]*1];
	NSNumber *ng2=[[NSNumber alloc] initWithInt:[[nv21 currentTitle] intValue]*10+[[nv22 currentTitle] intValue]*1];
	NSNumber *ng3=[[NSNumber alloc] initWithInt:[[na1 currentTitle] intValue]*10+[[na2 currentTitle] intValue]*1];
	NSNumber *nsign=[[NSNumber alloc] initWithInt:([(UIButton *)[self viewWithTag:12] currentTitle]==@" "?-1:([(UIButton *)[self viewWithTag:12] currentTitle]==@"+"?0:1))];
	if([viewController respondsToSelector:@selector(submitUserAnswerWithValues:)]) {
		[viewController submitUserAnswerWithValues:[[NSArray alloc] initWithObjects:ng1,ng2,ng3,nsign,nil]];
	}
}
- (void) PressAnswerButton:(id)sender event:(UIEvent *)e {
	[(UIButton *)[self viewWithTag:19] setTitle:@"=" forState:UIControlStateNormal];
}

//for pressTutorialButton & button it self
- (UIButton *)numberKeyMap:(int) num {
	UIButton *BUTTON;
	switch (num) {
		case 0:
			BUTTON = (UIButton *)[self viewWithTag:22];
			break;
		case 1:
			BUTTON = (UIButton *)[self viewWithTag:15];
			break;
		case 2:
			BUTTON = (UIButton *)[self viewWithTag:16];
			break;
		case 3:
			BUTTON = (UIButton *)[self viewWithTag:17];
			break;
		case 4:
			BUTTON = (UIButton *)[self viewWithTag:8];
			break;
		case 5:
			BUTTON = (UIButton *)[self viewWithTag:9];
			break;
		case 6:
			BUTTON = (UIButton *)[self viewWithTag:10];
			break;
		case 7:
			BUTTON = (UIButton *)[self viewWithTag:1];
			break;
		case 8:
			BUTTON = (UIButton *)[self viewWithTag:2];
			break;
		case 9:
			BUTTON = (UIButton *)[self viewWithTag:3];
			break;
		default:
			break;
	}
	return BUTTON;
}
- (void) diminishButton:(id)sender {
	[UIView animateWithDuration:0.9 animations:^{
		sleep(1);
		[(UIButton *)sender setTransform:CGAffineTransformMakeScale(1, 1)];
		[(UIButton *)sender setHighlighted:NO];
	}];
}
- (void) inflateButton:(id)sender {
	UIButton *pressed =sender;
	switch (pressed.tag) {
		case 1: case 2: case 3:
		case 8: case 9: case 10:
		case 15:case 16:case 17:
		case 22:// numberKeypad
			[self PressNumberKeypad:sender event:nil];
			break;
		case 4://clear
			[self PressClearButton:sender event:nil];
			break;
		case 5: //tutorial
			[self PressTutorialButton:sender event:nil];
			break;
		case 11: case 18: //signs
			[self PressSignButton:sender event:nil];
			break;
		case 23: //answer
			[self PressAnswerButton:sender event:nil];
			break;
		case 24: //submit
//			[self PressSubmitButton:sender event:nil];
			break;
		default:
			break;
	}
	[UIView animateWithDuration:0.9 animations:^{
		[(UIButton *)sender setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
		[(UIButton *)sender setHighlighted:YES];
		[NSThread detachNewThreadSelector:@selector(diminishButton:) toTarget:self withObject:sender];
	}];	
}
- (void) clearEvent:(id)sender {
	[self PressClearButton:sender event:nil];
}
- (void) PressTutorialButton:(id)sender event:(UIEvent *)e {
	int row1,row2,row3;
	if([sender tag]==4) {
 		row1=nv1, row2=nv2, row3=correct;
	} else {
		UIButton *bSender=sender;
		NSString *title = [bSender currentTitle];
		NSString *temp;
		if([title length]==3) {
			temp=[title substringToIndex:1];
			row1=[temp intValue];
			temp=[title substringFromIndex:1];
			row2=[temp intValue];
			row3=row1+row2;
			row2=abs(row2);
		} else {
			temp=[title substringToIndex:2];
			row1=[temp intValue];
			if(row1<10)
				temp=[title substringFromIndex:1];
			else
				temp=[title substringFromIndex:2];
			row2=[temp intValue];
			row3=row1+row2;
			row2=abs(row2);
		}
	}
	[NSThread detachNewThreadSelector:@selector(clearEvent:) toTarget:self withObject:nil];
	sleep(1);
	//row1
	if(row1<10){
		[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self numberKeyMap:row1]];
	}else {
		[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self numberKeyMap:row1/10]];
		sleep(1);
		[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self numberKeyMap:row1%10]];
	}
	sleep(1);
	//sign proc
	if(row3==row1+row2){
		[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self viewWithTag:11]];
	}else {
		[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self viewWithTag:18]];
	}
	sleep(1);
	//row2
	if (row2<10) {
		[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self numberKeyMap:row2]];
	}else {
		[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self numberKeyMap:row2/10]];
		sleep(1);
		[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self numberKeyMap:row2%10]];
	}
	sleep(1);
	//answer proc
	[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self viewWithTag:23]];
	sleep(1);
	//row3
	if (row3<10) {
		[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self numberKeyMap:row3]];
	} else {
		[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self numberKeyMap:row3/10]];
		sleep(1);
		[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self numberKeyMap:row3%10]];
	}
	sleep(1);
	[NSThread detachNewThreadSelector:@selector(inflateButton:) toTarget:self withObject:[self viewWithTag:24]];
	[self PressClearButton:nil event:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		// Initialization code
		const NSInteger GAP = 8;
		const NSInteger RIN_WIDTH= (frame.size.width-GAP*8)/7;
		const NSInteger RIN_HEIGHT=(frame.size.height-GAP*5)/4;
		if(frame.size.height<GAP*5 || frame.size.width<GAP*8)
			return self;
		NSString *titles[]={
			@"7", @"8", @"9", @"C", @"Tutorial", @"##", @"#",
			@"4", @"5", @"6", @"+", @"SIGN", @"##", @"#",
			@"1", @"2", @"3", @"-", @"###", @"##", @"#",
			@"0", @"=", @"SUBMIT!!!"
		};
		for (int i=0 ; i<7 ; i++) {
			for(int j=0 ; j<3 ; j++) {
				[self addSubview:[self addButton:titles[j*7+i] parrentBound:CGRectMake(GAP+(RIN_WIDTH+GAP)*i,GAP+(RIN_HEIGHT+GAP)*j,RIN_WIDTH,RIN_HEIGHT) Tag:j*7+i+1]];
			}
		}
		[self addSubview:[self addButton:titles[21] parrentBound:CGRectMake(GAP+(RIN_WIDTH+GAP)*1,GAP+(RIN_HEIGHT+GAP)*3,RIN_WIDTH,RIN_HEIGHT) Tag:22]];
		[self addSubview:[self addButton:titles[22] parrentBound:CGRectMake(GAP+(RIN_WIDTH+GAP)*3,GAP+(RIN_HEIGHT+GAP)*3,RIN_WIDTH,RIN_HEIGHT) Tag:23]];
		[self addSubview:[self addButton:titles[23] parrentBound:CGRectMake(GAP+(RIN_WIDTH+GAP)*4,GAP+(RIN_HEIGHT+GAP)*3,3*RIN_WIDTH+2*GAP,RIN_HEIGHT) Tag:24]];
//		[self setBackgroundColor:[UIColor orangeColor]]; // will BE
		[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backbord.png"]]];
		for(int i=0;i<24;i++){
			switch (i+1) {
				case 1: case 2: case 3:
				case 8: case 9: case 10:
				case 15:case 16:case 17:
				case 22:// numberKeypad
					[(UIButton *)[self viewWithTag:i+1] addTarget:self action:@selector(PressNumberKeypad:event:) forControlEvents:UIControlEventTouchUpInside];
					break;
				case 4://clear
					[(UIButton *)[self viewWithTag:i+1] addTarget:self action:@selector(PressClearButton:event:) forControlEvents:UIControlEventTouchUpInside];
					break;
				case 5: //tutorial
					[(UIButton *)[self viewWithTag:i+1] addTarget:self action:@selector(PressTutorialButton:event:) forControlEvents:UIControlEventTouchUpInside];
					break;
				case 11: case 18: //signs
					[(UIButton *)[self viewWithTag:i+1] addTarget:self action:@selector(PressSignButton:event:) forControlEvents:UIControlEventTouchUpInside];
					break;
				case 23: //answer
					[(UIButton *)[self viewWithTag:i+1] addTarget:self action:@selector(PressAnswerButton:event:) forControlEvents:UIControlEventTouchUpInside];
					break;
				case 24: //submit
					[(UIButton *)[self viewWithTag:i+1] addTarget:self action:@selector(PressSubmitButton:event:) forControlEvents:UIControlEventTouchUpInside];
					break;
				case 12:
				default:
					//tag 6,7,
					//12,13,14,
					//19,20,21
					[[self viewWithTag:i+1] setUserInteractionEnabled:NO];
					break;
			}
		}
		[self PressClearButton:self event:nil];
    }
	
    return self;
}

@end
