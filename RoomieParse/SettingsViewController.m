//
//  SettingsViewController.m
//  RoomieParse
//
//  Created by Dylan Bourgeois on 23/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.userInteractionEnabled = NO;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)inviteFriends:(id)sender {
}
- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [PFQuery clearAllCachedResults];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.userName.text = [self.userText uppercaseString];
    self.karma.text = [NSString stringWithFormat:@"%@",self.userKarma];

    if ([self.userKarma intValue] > 0) {
        self.karma.textColor = [UIColor colorWithRed:150./255
                                                         green:210./255
                                                          blue:149./255
                                                         alpha:1];
    }
    
    else if ([self.userKarma intValue] < 0) {
        self.karma.textColor = [UIColor colorWithRed:254./255
                                               green:150./255
                                                blue:68./255
                                               alpha:1];
    }
    else {
        self.karma.textColor = [UIColor grayColor];
    }
    
    
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        self.buttonInvite.frame = CGRectMake(self.buttonInvite.frame.origin.x, self.buttonInvite.frame.origin.y - 88, self.buttonInvite.frame.size.width, self.buttonInvite.frame.size.height);
        self.buttonDisconnect.frame = CGRectMake(self.buttonDisconnect.frame.origin.x, self.buttonDisconnect.frame.origin.y - 88, self.buttonDisconnect.frame.size.width, self.buttonDisconnect.frame.size.height);
    }
    
    [self.tableView reloadData];
}

- (IBAction)edit:(id)sender {
    [self.tableView setEditing:(self.tableView.isEditing ? NO : YES) ];
    
    if (self.tableView.isEditing) {
        self.tableView.userInteractionEnabled = YES;
        [self.editButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Done"] forState:UIControlStateNormal];
    }
    else
    {
        self.tableView.userInteractionEnabled = NO;
        [self.editButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Edit"] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableView.isEditing ? [self.roomies count]+1 : [self.roomies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] ;
    }
    
    if (indexPath.row < [self.roomies count])
    {
        cell.textLabel.text = [[self.roomies objectAtIndex:indexPath.row] uppercaseString];
    }
    
    else if (indexPath.row == [self.roomies count]) {
        if (!self.tx) {
            self.tx= [[UITextField alloc] initWithFrame:CGRectMake(15, 5*indexPath.row, 185, 30)];
            self.tx.delegate = self;
            self.tx.keyboardAppearance = UIKeyboardAppearanceDark;
            self.tx.returnKeyType = UIReturnKeyDone;
            self.tx.adjustsFontSizeToFitWidth = YES;
            self.tx.textColor = [UIColor whiteColor];
            UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
            self.tx.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add a roommate here !" attributes:@{NSForegroundColorAttributeName: color}];
            self.tx.font = [UIFont fontWithName:@"Futura" size:24];
            self.tx.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            self.tx.autocorrectionType = UITextAutocorrectionTypeNo;
            [self.tx setEnabled:YES];
            [self.tx setHidden:NO];
            [cell.contentView addSubview:self.tx];
            
            [cell.textLabel setText:@""];
            
        }
        else {
            [self.tx setEnabled:YES];
            [self.tx setHidden:NO];
            self.tx.frame = CGRectMake(15, 5*indexPath.row, 185, 30);
            UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
            self.tx.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add a roommate here !" attributes:@{NSForegroundColorAttributeName:color }];
            [cell.contentView addSubview:self.tx];
            [cell.textLabel setText:@""];
            
        }
        
    }
    
    
    cell.backgroundColor = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:24];
    self.tableView.separatorColor = [UIColor clearColor];
    
    return cell;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        if (indexPath.row < self.roomies.count ) {
            return UITableViewCellEditingStyleDelete;
        } else {
            return UITableViewCellEditingStyleInsert;
        }
    }
    
    else return UITableViewCellEditingStyleNone;
    
}

- (void) tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editing forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( editing == UITableViewCellEditingStyleDelete ) {
        PFUser *user = [PFUser currentUser];

        Reachability* reach = [Reachability reachabilityForInternetConnection];
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:[user.username uppercaseString]];
        if(![reach isReachable]) query.cachePolicy = kPFCachePolicyCacheElseNetwork ;
        else query.cachePolicy = kPFCachePolicyNetworkElseCache;
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
                
            } else {
                
                [object removeObject:[[self.roomies objectAtIndex:indexPath.row] uppercaseString] forKey:@"roommates"];
                Reachability* reach = [Reachability reachabilityForInternetConnection];
                if([reach isReachable]) [object saveInBackground];
                else [object saveEventually];
            }
            [self.roomies removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    if (![textField.text isEqualToString:@""""] && ![textField.text isEqualToString:@" "] && ![textField.text isEqualToString:@""])
    {
    [self.roomies addObject:[textField.text uppercaseString]];
    [self.tableView setEditing:NO];
    PFUser *user = [PFUser currentUser];

    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[user.username uppercaseString]];
    
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    if(![reach isReachable]) {
        query.cachePolicy = kPFCachePolicyCacheElseNetwork ;

    }
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            [object addObject:[textField.text uppercaseString] forKey:@"roommates"];
            
            Reachability* reach = [Reachability reachabilityForInternetConnection];
            if([reach isReachable]) [object saveInBackground];
            else [object saveEventually];
        }
    }];
    }
    
    [self.editButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Edit"] forState:UIControlStateNormal];
    self.tx.hidden=YES;
    self.tx.enabled=NO;
    [self.tableView setEditing:NO];
    self.tx.text = @"";
    [self.tableView reloadData];

    return NO;
}


@end
