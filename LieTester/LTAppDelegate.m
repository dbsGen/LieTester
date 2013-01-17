//
//  LTAppDelegate.m
//  LieTester
//
//  Created by zrz on 13-1-16.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTAppDelegate.h"

#import "LTViewController.h"
#import "LTTesterViewController.h"

@implementation LTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *ctrl = [[LTViewController alloc] initWithNibName:@"LTViewController" bundle:nil];
    
//    UIViewController *ctrl = [[LTTesterViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    nav.navigationBarHidden = YES;
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [(UINavigationController*)self.window.rootViewController visibleViewController] ==
       [LTTesterViewController sharedDirector] )
		[[LTTesterViewController sharedDirector] pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [(UINavigationController*)self.window.rootViewController visibleViewController] ==
       [LTTesterViewController sharedDirector])
		[[LTTesterViewController sharedDirector] resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [(UINavigationController*)self.window.rootViewController visibleViewController] ==
       [LTTesterViewController sharedDirector] )
		[[LTTesterViewController sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [(UINavigationController*)self.window.rootViewController visibleViewController] ==
       [LTTesterViewController sharedDirector] )
		[[LTTesterViewController sharedDirector] startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[LTTesterViewController sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[LTTesterViewController sharedDirector] setNextDeltaTimeZero:YES];
}

@end
