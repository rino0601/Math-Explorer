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

@property(strong, nonatomic) NSMutableArray *homeBackup;
@property(nonatomic) NSUInteger langCode;
@property(nonatomic) NSUInteger problemID;
@property(nonatomic, readonly) sqlite3 *dbo;
@property(strong, nonatomic) UIWindow *mainWindow;
@property(nonatomic) BOOL GONEXT;

-(NSUInteger)nextProblem;

@end