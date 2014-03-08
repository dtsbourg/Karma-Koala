//
//  SettingsViewController.h
//  RoomieParse
//
//  Created by Dylan Bourgeois on 23/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomieHeader.h"

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,FUIAlertViewDelegate>
/* ========== IBOutlets ==========*/
@property (strong, nonatomic) IBOutlet UILabel     * userName;
@property (strong, nonatomic) IBOutlet UILabel     * karma;

@property (strong, nonatomic) IBOutlet UITableView * tableView;
@property (strong, nonatomic) IBOutlet UITextField * tx;

@property (strong, nonatomic) IBOutlet UIButton    * editButton;
@property (strong, nonatomic) IBOutlet UIButton    * buttonDisconnect;
@property (strong, nonatomic) IBOutlet UIButton    * buttonInvite;

/* ========== Class Properties ==========*/
@property (strong, nonatomic) NSString       * userText;
@property (strong, nonatomic) NSString       * userKarma;
@property (strong, nonatomic) NSMutableArray * roomies;
@end
