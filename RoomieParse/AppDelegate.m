//
//  AppDelegate.m
//  RoomieParse
//
//  Created by Dylan Bourgeois on 19/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "AppDelegate.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"SxNsyhkZsT98RGCom5S5WWv1IoMNctxDg8KmfjKt"
                  clientKey:@"CuvUVmO7kA3FTaxx8rdQ21YpXMpasSExSvlnNsrd"];
    
    [Parse offlineMessagesEnabled:NO];
    [Parse errorMessagesEnabled:NO];
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"d77409b00e724effff5f11a2858a4dcf" delegate:self];
    [[BITHockeyManager sharedHockeyManager].authenticator setAuthenticationSecret:@"92c567f7ebd679d572c672e4fb3c9ef3"];
    [[BITHockeyManager sharedHockeyManager].authenticator setIdentificationType:BITAuthenticatorIdentificationTypeHockeyAppEmail];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([userInfo objectForKey:@"alert"]) {
        NSString *message = [userInfo objectForKey:@"alert"];
        
        FUIAlertView *al                      = [[FUIAlertView alloc] initWithTitle:@"Hey !"
                                                                            message:message
                                                                           delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
        
        al.titleLabel.textColor               = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
        al.titleLabel.font                    = [UIFont fontWithName:@"Futura" size:20];
        al.messageLabel.textColor             = [UIColor cloudsColor];
        al.messageLabel.font                  = [UIFont fontWithName:@"Futura" size:20];
        al.backgroundOverlay.backgroundColor  = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:0.7];
        al.alertContainer.backgroundColor     = [UIColor colorWithRed:83./255 green:38./255 blue:64./255 alpha:1];
        al.defaultButtonColor                 = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1];
        al.defaultButtonShadowColor           = [UIColor clearColor];
        al.defaultButtonFont                  = [UIFont fontWithName:@"Futura" size:20];
        al.defaultButtonTitleColor            = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
        al.alertContainer.layer.cornerRadius  = 5;
        al.alertContainer.layer.masksToBounds = YES;
        [al show];

    }
//
//    if ([userInfo objectForKey:@"badge"]) {
//        NSInteger badgeNumber = [[userInfo objectForKey:@"badge"] integerValue];
//        [application setApplicationIconBadgeNumber:badgeNumber];
//    }
    
//    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}

@end
