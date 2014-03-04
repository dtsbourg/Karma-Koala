//
//  HomeViewController.h
//  RoomieParse
//
//  Created by Dylan Bourgeois on 22/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <Parse/Parse.h>
#import "HMSegmentedControl/HMSegmentedControl.h"
#import "FlatUIKit.h"
#import "Reachability.h"

@interface HomeViewController : PFQueryTableViewController <FUIAlertViewDelegate>
@property (strong, nonatomic) NSString * displayUser;
@property (strong, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) NSMutableArray * array;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@end
