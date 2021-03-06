//
//  CIHDraggableImageView.h
//  CIHSketchApp
//
//  Created by Cyrus Hackford on 3/1/12.
//  Copyright (c) 2012 SI devIk. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CIHDraggableImageViewDelegate;

@interface CIHDraggableImageView:UIImageView {
	UIImageView *copycat;
	CGPoint handleDiffFromOrigin;
	id <CIHDraggableImageViewDelegate> delegate;
}
-(void)setDelegate:(id)Delegate;

@end

@protocol CIHDraggableImageViewDelegate <NSObject>

@optional
-(void)draggableImageView:(CIHDraggableImageView *)view dragFinishedOnKeyWindowAt:(CGPoint)groundZero;
-(UIView *)getSketchFrame;
@end