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
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)inviteFriends:(id)sender {
}
- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    else {
        self.tx= [[UITextField alloc] initWithFrame:CGRectMake(15, cell.frame.origin.y+10, 185, 30)];
        self.tx.delegate = self;
        self.tx.keyboardAppearance = UIKeyboardAppearanceDark;
        self.tx.returnKeyType = UIReturnKeyDone;
        self.tx.adjustsFontSizeToFitWidth = YES;
        self.tx.textColor = [UIColor whiteColor];
        self.tx.placeholder = @"Add a roommate !";
        self.tx.font = [UIFont fontWithName:@"Futura" size:24];
        self.tx.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        self.tx.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.tx setEnabled:YES];
        [cell.contentView addSubview:self.tx];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:24];
    self.tableView.separatorColor = [UIColor clearColor];
    
    return cell;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.roomies.count ) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleInsert;
    }
    
}

-(void)setEditing:(BOOL)editing animated:(BOOL) animated {
    if( editing != self.editing ) {
        
        [super setEditing:editing animated:animated];
        [self.tableView setEditing:editing animated:animated];
        
        NSArray *indexes =
        [NSArray arrayWithObject:
         [NSIndexPath indexPathForRow:self.roomies.count inSection:0]];
        if (editing == YES ) {
            [self.tableView insertRowsAtIndexPaths:indexes
                             withRowAnimation:UITableViewRowAnimationLeft];
        } else {
            [self.tableView deleteRowsAtIndexPaths:indexes
                             withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (void) tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editing forRowAtIndexPath:(NSIndexPath *)indexPath {
    if( editing == UITableViewCellEditingStyleDelete ) {        
        PFUser *user = [PFUser currentUser];
        // Do any additional setup after loading the view.
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:user.username];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
                
            } else {
                [object removeObject:[[self.roomies objectAtIndex:indexPath.row] lowercaseString] forKey:@"roommates"];
                [object saveInBackground];
            }
            self.tableView.editing = NO;
            [self.roomies removeObjectAtIndex:indexPath.row];
            
            [self.tableView reloadData];
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [self.roomies addObject:textField.text];
    self.tableView.editing = NO;
    PFUser *user = [PFUser currentUser];
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:user.username];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            [object addObject:[textField.text lowercaseString] forKey:@"roommates"];
            [object saveInBackground];
        }
    }];

    [self.tableView reloadData];
    return NO;
}


@end
