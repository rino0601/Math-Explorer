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
}

-(void)draggableImageView:(CIHDraggableImageView *)view dragFinishedOnKeyWindowAt:(CGPoint)groundZero;

@end