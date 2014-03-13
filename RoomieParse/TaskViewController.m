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
#import "HomeViewController.h"


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
        self.priority       = @"dateLimit";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    Reachability* reach = [Reachability reachabilityForInternetConnection];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];
    
    if ([PFUser currentUser]) {
    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
    [[PFInstallation currentInstallation] saveEventually];
    }
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
   
    
    if ([PFUser currentUser]) {
        
        self.firstNameLabel.text = [[PFUser currentUser].username uppercaseString];
        
        Reachability* reach = [Reachability reachabilityForInternetConnection];
        PFUser *user = [PFUser currentUser];
        // Do any additional setup after loading the view.
        
        PFQuery *query = [PFUser query];
        if(![reach isReachable]) query.cachePolicy = kPFCachePolicyCacheElseNetwork ;
        else query.cachePolicy = kPFCachePolicyCacheThenNetwork ;
        
        [query whereKey:@"username" equalTo:[user.username uppercaseString]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else {
                
                self.roommateArray = [object objectForKey:@"roommates"];
                
                if ([self.roommateArray count]==0)
                {
                    FUIAlertView *al                      = [[FUIAlertView alloc] initWithTitle:@"Hey!"
                                                                                        message:[NSString stringWithFormat:@"You don't seem to have any roommates ! Add one to get started !"]
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"I want to stay alone"
                                                                              otherButtonTitles:@"Add a roommate",nil];

                    al.titleLabel.textColor               = [UIColor colorWithRed:244./255
                                                                            green:157./255
                                                                             blue:25./255
                                                                            alpha:1];
                    
                    al.titleLabel.font                    = [UIFont fontWithName:@"Futura" size:20];
                    al.messageLabel.textColor             = [UIColor cloudsColor];
                    al.messageLabel.font                  = [UIFont fontWithName:@"Futura" size:20];
                    
                    al.backgroundOverlay.backgroundColor  = [UIColor colorWithRed:53./255
                                                                            green:25./255
                                                                             blue:55./255
                                                                            alpha:1];
                    
                    al.alertContainer.backgroundColor     = [UIColor colorWithRed:83./255
                                                                            green:38./255
                                                                             blue:64./255
                                                                            alpha:1];
                    
                    al.defaultButtonColor                 = [UIColor colorWithRed:53./255
                                                                            green:25./255
                                                                             blue:55./255
                                                                            alpha:1];
                    
                    al.defaultButtonShadowColor           = [UIColor clearColor];
                    al.defaultButtonFont                  = [UIFont fontWithName:@"Futura" size:20];
                    
                    al.defaultButtonTitleColor            = [UIColor colorWithRed:244./255
                                                                            green:157./255
                                                                             blue:25./255
                                                                            alpha:1];
                    al.alertContainer.layer.cornerRadius  = 5;
                    al.alertContainer.layer.masksToBounds = YES;
                    [al show];
                }
            
                if ([[object objectForKey:@"karma"] intValue] > 0) {
                    self.karmaLabel.textColor = [UIColor colorWithRed:150./255
                                                                green:210./255
                                                                 blue:149./255
                                                                alpha:1];
                    
                    self.karmaLabel.text      = [NSString stringWithFormat:@"+%i", [[object objectForKey:@"karma"] intValue]];
                }
                
                else if ([[object objectForKey:@"karma"] intValue] < 0) {
                    self.karmaLabel.textColor = [UIColor colorWithRed:244./255
                                                                green:157./255
                                                                 blue:25./255
                                                                alpha:1];
                    
                    self.karmaLabel.text      = [NSString stringWithFormat:@"%i", [[object objectForKey:@"karma"] intValue]];
                }
                
                else {
                    self.karmaLabel.text      = [NSString stringWithFormat:@"%i", [[object objectForKey:@"karma"] intValue]];
                    self.karmaLabel.textColor = [UIColor grayColor];
                }
                
                CGRect topFrame = CGRectMake(self.koala.frame.origin.x,
                                             20,
                                             self.koala.frame.size.width,
                                             self.koala.frame.size.height);
                
                int karma=[[object objectForKey:@"karma"]intValue];
                
                if (karma < 25){
                    [self.koala setImage:[UIImage imageNamed:@"koala_hip.gif"]];
                }
                
                else if (karma < 50){
                    [self.koala setImage:[UIImage imageNamed:@"koala_seated.gif"]];
                }
                
                else if (karma < 75){
                    [self.koala setImage:[UIImage imageNamed:@"Koala_yoda_cane.gif"]];
                }
                
                else if (karma < 100){
                    [self.koala setImage:[UIImage imageNamed:@"koala_yoda_swrd.gif"]];
                }
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationDelay:1.0];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                
                self.koala.frame = topFrame;
                [UIView commitAnimations];
            }
        }];
        
        if (user) {
            [self loadObjects];
        }
    }
    
    else {
        
        [PFQuery clearAllCachedResults];
        // Create the log in view controller
        LoginViewController *logInViewController   = [[LoginViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        logInViewController.fields                 = PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten ;

        // Create the sign up view controller
        SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate

        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        [self presentViewController:logInViewController animated:NO completion:NULL];
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
        NSIndexPath *selectedRowIndex    = [self.tableView indexPathForSelectedRow];
        destvc.taskText                  = [self.tableView cellForRowAtIndexPath:selectedRowIndex].textLabel.text;
        destvc.taskKarma                 = [self.tableView cellForRowAtIndexPath:selectedRowIndex].detailTextLabel.text;
    }
    
    else if ([segue.identifier isEqualToString:@"settingsSegue"]) {
        SettingsViewController *destvc = [segue destinationViewController];

        destvc.roomies                 = self.roommateArray;
        destvc.userKarma               = self.karmaLabel.text;
        destvc.userText                = [PFUser currentUser].username;
        
    }
    
    else if ([segue.identifier isEqualToString:@"homeSegue"]) {
        HomeViewController *destvc = [segue destinationViewController];
        destvc.array               = self.roommateArray;
        destvc.displayUser         = @"ALL";
    }
}

#pragma mark - Table View Controller Data Source

 - (PFQuery *)queryForTable {
     
    if ([PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query whereKey:@"user" equalTo:[[PFUser currentUser].username uppercaseString]];
        
        Reachability* reach = [Reachability reachabilityForInternetConnection];
        
        if(![reach isReachable]) {
            if (self.pullToRefreshEnabled) {
                query.cachePolicy = kPFCachePolicyCacheElseNetwork ;
            }

            if (self.objects.count == 0) {
                query.cachePolicy = kPFCachePolicyCacheElseNetwork ;
            }
            
            query.cachePolicy = kPFCachePolicyCacheElseNetwork ;
        }
        
        else {
            if (self.pullToRefreshEnabled) {
                query.cachePolicy = kPFCachePolicyCacheThenNetwork ;
            }

            if (self.objects.count == 0) {
                query.cachePolicy = kPFCachePolicyCacheThenNetwork ;
            }
            
            query.cachePolicy = kPFCachePolicyCacheThenNetwork ;
        }
        
        [query orderByDescending:self.priority];
 
        return query;
     }
     
     else return nil;
 }

#pragma mark - Table View Controller Delegate

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    [self.toDoNumberLabel setText:[NSString stringWithFormat:@"%li", (long)[tableView numberOfRowsInSection:0]]];
    
    static NSString *CellIdentifier = @"Cell";
 
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:CellIdentifier];
    }
        
     self.tableView.separatorColor = [UIColor clearColor];
    
     cell.textLabel.text       = [object objectForKey:@"taskId"];
     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"karma"]];
    
    if ([[object objectForKey:@"karma"] intValue] > 0) {
        cell.detailTextLabel.textColor = [UIColor colorWithRed:150./255
                                                         green:210./255
                                                          blue:149./255
                                                         alpha:1];
        
        cell.detailTextLabel.text      = [NSString stringWithFormat:@"+%@",[object objectForKey:@"karma"]];
    }
    
    else cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        
    if ([(NSDate*)[object objectForKey:@"dateLimit"] compare:[NSDate date]] == NSOrderedAscending)
    {
        cell.textLabel.textColor          = [UIColor colorWithRed:244./255
                                                            green:150./255
                                                             blue:68./255
                                                            alpha:1];

        NSDate *now                       = [NSDate date];
        NSTimeInterval secondsBetween     = [[object objectForKey:@"dateLimit"] timeIntervalSinceDate:now];
        NSTimeInterval secondsSinceUpdate = [[object updatedAt] timeIntervalSinceDate:now];

        int numberOfHours                 = secondsBetween / 3600, numberOfHoursSinceUpdate = secondsSinceUpdate / 3600;
        
        if (numberOfHoursSinceUpdate >= 12) {
            [object incrementKey:@"karma" byAmount:[NSNumber numberWithInt:numberOfHours*0.09]];
            
            Reachability* reach = [Reachability reachabilityForInternetConnection];
            if([reach isReachable]) [object saveInBackground];
            else [object saveEventually];
        }
    }
    
    else {
        cell.textLabel.textColor = [UIColor whiteColor];
    }

    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPage";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Load more...";
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:53./255
                                           green:25./255
                                            blue:55./255
                                           alpha:1];
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:24];
 
    return cell;
}


#pragma mark - Actions

- (IBAction)orderFeed:(id)sender {
    IBActionSheet *actionSheet = [[IBActionSheet alloc] initWithTitle:@"Order your task Feed by :"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Karma points", @"Date", nil, nil];
    
    [actionSheet setFont:[UIFont fontWithName:@"Futura" size:16]];
    
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:83./255
                                                          green:38./255
                                                           blue:64./255
                                                          alpha:1]];
    
    [actionSheet setButtonTextColor:[UIColor colorWithRed:150./255
                                                    green:210./255
                                                     blue:149./255
                                                    alpha:1]];
    
    [actionSheet setTitleTextColor:[UIColor colorWithRed:244./255
                                                   green:150./255
                                                    blue:68./255
                                                   alpha:1]];
    
    [actionSheet setButtonTextColor:[UIColor colorWithRed:244./255
                                                    green:150./255
                                                     blue:68./255
                                                    alpha:1]
                   forButtonAtIndex:2];
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Add a roommate"]){
        [self performSegueWithIdentifier:@"settingsSegue" sender:nil];
    } else {
        
    }
}
#pragma mark - UI
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect fixedFrame           = self.topView.frame;
    fixedFrame.origin.y         = 0 + scrollView.contentOffset.y;
    self.topView.frame          = fixedFrame;
    
}

#pragma mark - Reachability
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if(![reach isReachable]) {
    FUIAlertView *al                      = [[FUIAlertView alloc] initWithTitle:@"Oops!"
                                                                        message:[NSString stringWithFormat:@"You aren't connected to Internet at the moment. Get a life, go outside !"]
                                                                       delegate:self
                                                              cancelButtonTitle:@"I'll be back !"
                                                              otherButtonTitles:nil];

    al.titleLabel.textColor               = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
    al.titleLabel.font                    = [UIFont fontWithName:@"Futura" size:20];
    al.messageLabel.textColor             = [UIColor cloudsColor];
    al.messageLabel.font                  = [UIFont fontWithName:@"Futura" size:20];
    al.backgroundOverlay.backgroundColor  = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1];
    al.alertContainer.backgroundColor     = [UIColor colorWithRed:83./255 green:38./255 blue:64./255 alpha:1];
    al.defaultButtonColor                 = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1];
    al.defaultButtonShadowColor           = [UIColor clearColor];
    al.defaultButtonFont                  = [UIFont fontWithName:@"Futura" size:20];
    al.defaultButtonTitleColor            = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
    al.alertContainer.layer.cornerRadius  = 5;
    al.alertContainer.layer.masksToBounds = YES;
    [al show];
  }

}

#pragma mark - Signup
// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [user setObject:[NSNumber numberWithInt:1] forKey:@"karma"];
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

#pragma mark - Login

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

@end
