//
//  MEAppDelegate.h
//  Math Explorer
//
//  Created by Hyun Hwang on 7/4/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface MEAppDelegate:UIResponder <UIApplicationDelegate> {
@private
	UINavigationController *navController;
}

@property(strong, readonly, nonatomic) NSMutableArray *vcBackups;
@property(nonatomic) NSUInteger langCode;
@property(nonatomic, readonly) sqlite3 *dbo;
@property(strong, nonatomic) UIWindow *mainWindow;

@end