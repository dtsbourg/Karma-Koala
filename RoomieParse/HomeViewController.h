//
//  HomeViewController.h
//  RoomieParse
//
//  Created by Dylan Bourgeois on 22/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <Parse/Parse.h>
#import "HMSegmentedControl/HMSegmentedControl.h"

@interface HomeViewController : PFQueryTableViewController
@property (strong, nonatomic) NSString * displayUser;
@property (strong, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) NSMutableArray * array;
@end
