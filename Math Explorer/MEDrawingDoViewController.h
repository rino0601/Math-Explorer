//
//  MEDrawingDoViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"
#import "CIHDraggableImageView.h"
#import <AVFoundation/AVFoundation.h>

@class  CIHCanvasView;
@class MEDrawingAskViewController;

@interface MEDrawingDoViewController:MEPageTemplateViewController <CIHDraggableImageViewDelegate>{
	@private
	AVAudioPlayer *avp;
	BOOL isGoodToContinue;
	CIHCanvasView *canvas;
	MEDrawingAskViewController *meDrawingAskActivity;
	IBOutlet UILabel *meDrawingDoInstruction;
	IBOutlet UISegmentedControl *DRColor, *DRThick;
	NSMutableArray *mArray;
	CIHDraggableImageView *item1, *item2;
}

-(IBAction)lineColorChanged:(id)sender;
-(IBAction)lineWidthChanged:(id)sender;

-(void)draggableImageView:(CIHDraggableImageView *)view dragFinishedOnKeyWindowAt:(CGPoint)groundZero;

@end