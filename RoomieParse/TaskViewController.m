//
//  TaskViewController.m
//  RoomieParse
//
//  Created by Dylan Bourgeois on 19/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "TaskViewController.h"

@interface TaskViewController ()

@end

@implementation TaskViewController
- (IBAction)logout:(id)sender {
    
    [PFUser logOut];
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsLogInButton ;
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
    
}

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
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"Tasks";
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsLogInButton ;
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
 PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
 
 // If Pull To Refresh is enabled, query against the network by default.
 if (self.pullToRefreshEnabled) {
 query.cachePolicy = kPFCachePolicyNetworkOnly;
 }
 
 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.
 if (self.objects.count == 0) {
 query.cachePolicy = kPFCachePolicyCacheThenNetwork;
 }
 
 [query orderByDescending:@"updatedAt"];
 
 return query;
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
 
 // Configure the cell
     cell.textLabel.text = [object objectForKey:@"taskId"];
     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"karma"]];
 
 return cell;
 }


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

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
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
