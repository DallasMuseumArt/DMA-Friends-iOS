//
//  DMAAppDelegate_iPad.m
//  DMAKiosk
//
//  Created by Christopher Luu on 1/2/13.
//  Copyright (c) 2013 LearningTimes. All rights reserved.
//

#import "DMAAppDelegate_iPad.h"

#import "DMAMainViewController_iPad.h"

@implementation DMAAppDelegate_iPad

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	BOOL tmpRetVal = [super application:application didFinishLaunchingWithOptions:launchOptions];
	
	DMAMainViewController_iPad *tmpViewController = [[DMAMainViewController_iPad alloc] init];
	UINavigationController *tmpNavController = [[UINavigationController alloc] initWithRootViewController:tmpViewController];
	[tmpNavController setNavigationBarHidden:YES];
	[self.window setRootViewController:tmpNavController];
	
	return tmpRetVal;
}

@end
