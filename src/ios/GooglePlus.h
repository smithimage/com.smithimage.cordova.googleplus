//
//  GooglePlus.h
//  idive
//
//  Created by Robert Wallstrom on 9/8/13.
//
//

#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>
#import <GooglePlus/GooglePlus.h>

@interface GooglePlus : CDVPlugin<GPPSignInDelegate, GPPShareDelegate> {
    
}

- (void) initialize: (CDVInvokedUrlCommand*) command;

- (void)authenticate:(CDVInvokedUrlCommand*)command;

- (void)share:(CDVInvokedUrlCommand*)command;


+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation NS_AVAILABLE_IOS(4_2);

@end
