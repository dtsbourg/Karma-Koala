//
//  TaskViewController.h
//  RoomieParse
//
//  Created by Dylan Bourgeois on 19/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <Parse/Parse.h>

@interface TaskViewController : PFQueryTableViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *karmaLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicLabel;

@end
