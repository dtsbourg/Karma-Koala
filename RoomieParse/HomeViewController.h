//
//  HomeViewController.h
//  RoomieParse
//
//  Created by Dylan Bourgeois on 22/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <Parse/Parse.h>

@interface HomeViewController : PFQueryTableViewController
@property (strong, nonatomic) NSString * displayUser;
@end
