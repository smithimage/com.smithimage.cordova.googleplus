    //
//  AppDelegate+GooglePlus.h
//  idive
//
//  Created by Robert Wallstrom on 25/12/13.
//
//

#import "AppDelegate.h"

@interface AppDelegate (GooglePlus)
- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url  sourceApplication: (NSString *)sourceApplication annotation: (id)annotation;

@end
