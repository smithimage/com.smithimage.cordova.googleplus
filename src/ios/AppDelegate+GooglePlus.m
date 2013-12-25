//
//  AppDelegate+GooglePlus.m
//  idive
//
//  Created by Robert Wallstrom on 25/12/13.
//
//

#import "AppDelegate+GooglePlus.h"
#import "GooglePlus.h"

@implementation AppDelegate (GooglePlus)
- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    
    if([GooglePlus application:application openURL:url sourceApplication:sourceApplication annotation:annotation])
        return YES;
    else
        return [self application:application handleOpenURL:url];
}

@end
