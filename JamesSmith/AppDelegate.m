//
//  AppDelegate.m
//  JamesSmith
//
//  Created by Jamie Smith on 4/11/14.
//  Copyright (c) 2014 James Smith. All rights reserved.
//

#import "AppDelegate.h"

// SDKs
#import "Overshare Kit/OvershareKit.h"
#import "OSKADNLoginManager.h"
#import "PocketAPI.h"

static NSString * const kPocketConsumerKey = @"26297-bb4a404c6725d7fc56d7d5e0";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    window.backgroundColor = [UIColor whiteColor];
    
    [[PocketAPI sharedAPI] setConsumerKey:kPocketConsumerKey];
    [[OSKActivitiesManager sharedInstance] markActivityTypes:@[OSKActivityType_API_AppDotNet, OSKActivityType_API_GooglePlus] alwaysExcluded:YES];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL success = NO;
    
    if ([[PocketAPI sharedAPI] handleOpenURL:url]){
        success = YES;
    }
    else {
        // Other URL Schemes
    }
    
    return success;
}

@end
