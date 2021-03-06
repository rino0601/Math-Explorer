//
//  MEAskModalTemplateViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


extern NSString *const MEAskActivityConfirmed;

@interface MEAskModalTemplateViewController:UIViewController {
	@protected
	NSUInteger noCount;
	UIButton *utilSay, *chkNo, *chkYes, *chkAprv;
	MPMoviePlayerController *moviePlayer;
	AVAudioPlayer *playerAux;
}

-(void)sayButtonAction:(id)sender;
-(void)noButtonAction:(id)sender;
-(void)yesButtonAction:(id)sender;
-(void)approveButtonAction:(id)sender;

@end