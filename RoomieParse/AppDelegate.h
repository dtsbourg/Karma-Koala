//
//  AppDelegate.h
//  RoomieParse
//
//  Created by Dylan Bourgeois on 19/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HockeySDK/HockeySDK.h>
#import "RoomieHeader.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BITHockeyManagerDelegate, FUIAlertViewDelegate>


@property (strong, nonatomic) UIWindow *window;

@end
