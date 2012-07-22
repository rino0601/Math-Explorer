//
//  MEBTFViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 11..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import "MEPageTemplateViewController.h"

@interface MEBTFViewController : MEPageTemplateViewController
@property(strong,nonatomic) IBOutlet UILabel *BTFtitle;
@property(strong,nonatomic) IBOutlet UILabel *BTFcoment;
@property(strong,nonatomic) IBOutlet UILabel *problemMeter;
@property(strong,nonatomic) IBOutlet UISlider *problemSelecter;

-(IBAction)selectProblem:(UISlider *)sender;

@end
