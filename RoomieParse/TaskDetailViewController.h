//
//  TaskDetailViewController.h
//  RoomieParse
//
//  Created by Dylan Bourgeois on 20/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomieHeader.h"

@interface TaskDetailViewController : UIViewController <UIActionSheetDelegate, FUIAlertViewDelegate>
/* ========== IBOutlets ==========*/
@property (strong, nonatomic) IBOutlet UILabel *taskName;
@property (strong, nonatomic) IBOutlet UILabel *karma;
@property (strong, nonatomic) IBOutlet UILabel *timeLeft;

@property (strong, nonatomic) IBOutlet UIButton *daysLate;
@property (strong, nonatomic) IBOutlet UIButton *buttonDelay;
@property (strong, nonatomic) IBOutlet UIButton *buttonComplete;

/* ========== Class Properties ==========*/
@property (strong, nonatomic) NSString *taskText;
@property (strong, nonatomic) NSString *taskKarma;

@property (strong, nonatomic) NSDate *dueDate;
@property (weak, nonatomic) NSDate *delayDate;

@property (nonatomic, assign) int delayDay;
@end
