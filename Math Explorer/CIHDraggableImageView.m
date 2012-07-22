//
//  CIHDraggableImageView.m
//  CIHSketchApp
//
//  Created by Cyrus Hackford on 3/1/12.
//  Copyright (c) 2012 SI devIk. All rights reserved.
//

#import "CIHDraggableImageView.h"

@implementation CIHDraggableImageView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	handleDiffFromOrigin=[[touches anyObject] locationInView:self];
	
	copycat=[[UIImageView alloc] initWithFrame:[self bounds]];
	[copycat setImage:[[UIImage alloc] initWithCGImage:[self image].CGImage scale:1.0 orientation:UIImageOrientationLeft]];
	[[[UIApplication sharedApplication] keyWindow] addSubview:copycat];
	
	CGPoint locationInWindow=[[touches anyObject] locationInView:[[UIApplication sharedApplication] keyWindow]];
	[copycat setCenter:CGPointMake(locationInWindow.x,locationInWindow.y)];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint locationInWindow=[[touches anyObject] locationInView:[delegate getSketchFrame]];
	
	if([delegate respondsToSelector:@selector(draggableImageView:dragFinishedOnKeyWindowAt:)]==YES) {
		[delegate draggableImageView:self dragFinishedOnKeyWindowAt:CGPointMake(locationInWindow.x-([copycat bounds].size.width/2), locationInWindow.y-([copycat bounds].size.width/2))];
	}
	
	[copycat removeFromSuperview];
	copycat=nil;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint locationInWindow=[[touches anyObject] locationInView:[[UIApplication sharedApplication] keyWindow]];
	[copycat setCenter:CGPointMake(locationInWindow.x,locationInWindow.y)];
}
-(void)setDelegate:(id)Delegate {
	delegate=Delegate;
}

@end