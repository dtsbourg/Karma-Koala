//
//  HomeViewController.h
//  RoomieParse
//
//  Created by Dylan Bourgeois on 22/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "HMSegmentedControl/HMSegmentedControl.h"
#import "RoomieHeader.h"

@interface HomeViewController : PFQueryTableViewController <FUIAlertViewDelegate>
/* ========== IBOutlets ==========*/
@property (strong, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

/* ========== Class Properties ==========*/
@property (strong, nonatomic) NSMutableArray * array;

@property (strong, nonatomic) NSString * displayUser;
@end
