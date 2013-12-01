//
//  GooglePlus.m
//  idive
//
//  Created by Robert Wallstrom on 9/8/13.
//
//

#import "GooglePlus.h"

#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

@interface GooglePlus()
@property NSString *lasLogonCallbackId;
@property NSString *lastShareCallbackId;
@end

@implementation GooglePlus

- (void) initialize: (CDVInvokedUrlCommand*) command
{
    // Do any additional setup after loading the view from its nib.
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = [command.arguments objectAtIndex:0];	
    if([command.arguments count] > 1){
        signIn.scopes = [command.arguments objectAtIndex:1];
    }else{
        signIn.scopes = [NSArray arrayWithObjects: kGTLAuthScopePlusLogin, // defined in GTLPlusConstants.h
                         nil];
    }
    signIn.delegate = self;
}

- (void)authenticate:(CDVInvokedUrlCommand*)command
{
    if([self lasLogonCallbackId] != command.callbackId){
        [[self lasLogonCallbackId] release];
        [self setLasLogonCallbackId:[command.callbackId copy]];
    }
    
    [[GPPSignIn sharedInstance] authenticate];
}

- (void) signout:(CDVInvokedUrlCommand*)command
{
    [[GPPSignIn sharedInstance] signOut];
}

- (void)share:(CDVInvokedUrlCommand*)command
{
    
    if([self lastShareCallbackId] != command.callbackId){
        [[self lastShareCallbackId] release];
        [self setLastShareCallbackId:[command.callbackId copy]];
    }

    
    NSDictionary *dictionary = [command.arguments objectAtIndex:0];
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
     
     // This line will manually fill out the title, description, and thumbnail of the
     // item you're sharing.
    [shareBuilder setPrefillText:[dictionary objectForKey:@"prefillText"]];
    [shareBuilder setTitle:[dictionary objectForKey:@"title"]
     description:[dictionary objectForKey:@"description"]
               thumbnailURL:[NSURL URLWithString:[dictionary objectForKey:@"thumbNailUrl"]]];
    
    [shareBuilder setContentDeepLinkID:[dictionary objectForKey:@"deepLinkId"]];
    [shareBuilder open];
}

- (void)shareUrl:(CDVInvokedUrlCommand*)command
{
    if([self lastShareCallbackId] != command.callbackId){
        [[self lastShareCallbackId] release];
        [self setLastShareCallbackId:[command.callbackId copy]];
    }
    
    
    NSDictionary *dictionary = [command.arguments objectAtIndex:0];
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    NSString* text = [dictionary objectForKey:@"prefillText"];
    NSLog(@"text is: %@", text);
    
    [[[shareBuilder setURLToShare:[NSURL URLWithString:[dictionary objectForKey:@"url"]]]
        setPrefillText:[dictionary objectForKey:@"prefillText"]] open];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if(error)
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:[self lasLogonCallbackId]];
    else
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:auth.accessToken] callbackId:[self lasLogonCallbackId]];
}

- (void)didDisconnectWithError:(NSError *)error
{
}

- (void)handleOpenURL:(NSNotification*)notification
{
    
}

- (void)finishedSharing: (BOOL)shared
{
    if(shared)
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:[self lasLogonCallbackId]];
    else
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:[self lasLogonCallbackId]];
        
}

+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation NS_AVAILABLE_IOS(4_2)
{
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];    
}




- (void) dealloc
{
    [[self lasLogonCallbackId] release];
    [self setLasLogonCallbackId:nil];
    
    [[self lastShareCallbackId] release];
    [self setLastShareCallbackId:nil];
    
    [super dealloc];
}


@end
