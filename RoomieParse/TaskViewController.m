//
//  TaskViewController.m
//  RoomieParse
//
//  Created by Dylan Bourgeois on 19/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//


#import "TaskViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "TaskDetailViewController.h"
#import "SettingsViewController.h"


@interface TaskViewController ()
@end

@implementation TaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Tasks";
        self.objectsPerPage = 10;
        self.priority = @"dateLimit";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([PFUser currentUser]) self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser]) {
        [self loadObjects];
        
        PFUser *user = [PFUser currentUser];
        // Do any additional setup after loading the view.
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:user.username];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else {
                // The find succeeded.
                self.karmaLabel.text = [NSString stringWithFormat:@"%i", [[object objectForKey:@"karma"] intValue]];
                
                if ([[object objectForKey:@"karma"] intValue] > 0) {
                    self.karmaLabel.textColor = [UIColor colorWithRed:150./255
                                                                green:210./255
                                                                 blue:149./255
                                                                alpha:1];
                    
                    self.karmaLabel.text = [NSString stringWithFormat:@"+%i", [[object objectForKey:@"karma"] intValue]];
                }
                
                else if ([[object objectForKey:@"karma"] intValue] < 0) {
                    self.karmaLabel.textColor = [UIColor colorWithRed:244./255
                                                                green:157./255
                                                                 blue:25./255
                                                                alpha:1];
                }
                
                else self.karmaLabel.textColor = [UIColor grayColor];
            }
        }];
        
        if (user) {
            self.firstNameLabel.text = [user.username uppercaseString];
            [self loadObjects];
        }
    }
    
    else {
        // Create the log in view controller
        LoginViewController *logInViewController = [[LoginViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsLogInButton ;
        
        // Create the sign up view controller
        SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        TaskDetailViewController *destvc = [segue destinationViewController];
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        destvc.taskText = [self.tableView cellForRowAtIndexPath:selectedRowIndex].textLabel.text;
        destvc.taskKarma = [self.tableView cellForRowAtIndexPath:selectedRowIndex].detailTextLabel.text;
    }
    
    else if ([segue.identifier isEqualToString:@"settingsSegue"]) {
        SettingsViewController *destvc = [segue destinationViewController];
        
        PFUser *user = [PFUser currentUser];
        // Do any additional setup after loading the view.
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:user.username];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else {
                destvc.roomies = [object objectForKey:@"roommates"];
            }
        }];

        destvc.userKarma = self.karmaLabel.text;
        destvc.userText = [PFUser currentUser].username;
        
    }
}

 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
     
    if ([PFUser currentUser]) {
        
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query whereKey:@"user" equalTo:[PFUser currentUser].username];
 
        // If Pull To Refresh is enabled, query against the network by default.
        if (self.pullToRefreshEnabled) {
            query.cachePolicy = kPFCachePolicyNetworkOnly;
        }
         // If no objects are loaded in memory, we look to the cache first to fill the table
         // and then subsequently do a query against the network.
        if (self.objects.count == 0) {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        
        [query orderByDescending:self.priority];
 
        return query;
     }
     
     else return nil;
 }

 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     
 static NSString *CellIdentifier = @"Cell";
 
 PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
 }
     self.tableView.separatorColor = [UIColor clearColor];
 
    // Configure the cell
     cell.textLabel.text = [object objectForKey:@"taskId"];
     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"karma"]];
    
    if ([[object objectForKey:@"karma"] intValue] > 0) {
        cell.detailTextLabel.textColor = [UIColor colorWithRed:150./255
                                                    green:210./255
                                                     blue:149./255
                                                    alpha:1];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@",[object objectForKey:@"karma"]];
    }
    
    else cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    if ([(NSDate*)[object objectForKey:@"dateLimit"] compare:[NSDate date]] == NSOrderedAscending)
    {
        cell.textLabel.textColor = [UIColor colorWithRed:244./255
                                                   green:150./255
                                                    blue:68./255
                                                   alpha:1];

        NSDate *now = [NSDate date];
        NSTimeInterval secondsBetween = [[object objectForKey:@"dateLimit"] timeIntervalSinceDate:now];
        NSTimeInterval secondsSinceUpdate = [[object updatedAt] timeIntervalSinceDate:now];
        
        int numberOfHours = secondsBetween / 3600, numberOfHoursSinceUpdate = secondsSinceUpdate / 3600;
        
        if (numberOfHoursSinceUpdate >= 12) {
            [object incrementKey:@"karma" byAmount:[NSNumber numberWithInt:numberOfHours*0.08]];
            [object saveInBackground];
        }
    }
    
    else {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
}


// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)orderFeed:(id)sender {
    IBActionSheet *actionSheet = [[IBActionSheet alloc] initWithTitle:@"Order your task Feed by :"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Karma points", @"Date", nil, nil];
    
    [actionSheet setFont:[UIFont fontWithName:@"Futura" size:16]];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:83./255 green:38./255 blue:64./255 alpha:1]];
    [actionSheet setButtonTextColor:[UIColor colorWithRed:150./255 green:210./255 blue:149./255 alpha:1]];
    [actionSheet setTitleTextColor:[UIColor colorWithRed:244./255 green:150./255 blue:68./255 alpha:1]];
    [actionSheet setButtonTextColor:[UIColor colorWithRed:244./255 green:150./255 blue:68./255 alpha:1] forButtonAtIndex:2];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(IBActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.priority=@"karma";
            break;
        case 1:
            self.priority=@"dateLimit";
            break;
        default:
            break;
        }
    [self loadObjects];
}

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

@end
