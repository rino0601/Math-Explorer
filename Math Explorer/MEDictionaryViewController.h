//
//  MEDictionaryViewController.h
//  Math Explorer
//
//  Created by Hyun Hwang on 7/7/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MEDictionaryViewController:UISplitViewController

-(id)initWithDictionaryDataSource:(id<UITableViewDataSource>)ds;

@end