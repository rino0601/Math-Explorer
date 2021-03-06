//
//  MEAppDelegate.m
//  Math Explorer
//
//  Created by Hyun Hwang on 7/4/12.
//  Copyright (c) 2012 SI Cyrusian. All rights reserved.
//

#import "MEAppDelegate.h"
#import "MELangSelectViewController.h"


@implementation MEAppDelegate

@synthesize homeBackup, langCode, problemID=_problemID, dbo=_dbo, mainWindow=_mainWindow, goodToGo;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	sqlite3_open_v2([[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MEDatabase.sqlite3"] UTF8String], &_dbo, SQLITE_OPEN_READONLY, NULL);
	_problemID=0;
	
	MELangSelectViewController *startViewController=[[MELangSelectViewController alloc] initWithNibName:@"MELangSelectViewController" bundle:nil];
	navController=[[UINavigationController alloc] initWithRootViewController:startViewController];
	[navController setNavigationBarHidden:YES];
	
	_mainWindow=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[_mainWindow addSubview:[navController view]];
	[_mainWindow makeKeyAndVisible];
	
	return YES;
}

-(void)applicationWillTerminate:(UIApplication *)application {
	sqlite3_close(_dbo);
}

-(NSUInteger)nextProblem {
	NSUInteger stepProblemID=((_problemID-1)/12)*12+1;
	_problemID+=4;
	if(_problemID>stepProblemID+11){
		_problemID-=11;
		if(_problemID>stepProblemID+11)
			_problemID=stepProblemID;
	}
	return _problemID;
}

/*
-(void)applicationWillResignActive:(UIApplication *)application {}

-(void)applicationDidEnterBackground:(UIApplication *)application {}

-(void)applicationWillEnterForeground:(UIApplication *)application {}

-(void)applicationDidBecomeActive:(UIApplication *)application {}
//*/

@end