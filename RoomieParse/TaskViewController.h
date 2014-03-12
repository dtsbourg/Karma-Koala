//
//  TaskViewController.h
//  RoomieParse
//
//  Created by Dylan Bourgeois on 19/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "RoomieHeader.h"
#import "IBActionSheet.h"

@interface TaskViewController : PFQueryTableViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, IBActionSheetDelegate,FUIAlertViewDelegate>

/* ========== IBOutlets ==========*/
@property (strong, nonatomic) IBOutlet UILabel     * karmaLabel;
@property (strong, nonatomic) IBOutlet UILabel     * firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel     * toDoNumberLabel;

@property (strong, nonatomic) IBOutlet UIImageView * koala;

@property (strong, nonatomic) IBOutlet UIView      * topView;

/* ========== Class properties ==========*/
@property (strong,nonatomic)  NSString       * priority;

@property (nonatomic, strong) NSMutableArray * roommateArray;

@end
