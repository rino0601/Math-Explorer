//
//  MEDictionaryViewController.h
//  Math Explorer
//
//  Created by Hanjong Ko on 12. 7. 7..
//  Copyright (c) 2012년 SI Cyrusian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MEDictionaryViewController:UISplitViewController

-(id)initWithDictionaryDataSource:(id<UITableViewDataSource>)ds;

@end