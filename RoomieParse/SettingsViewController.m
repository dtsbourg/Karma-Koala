//
//  SettingsViewController.m
//  RoomieParse
//
//  Created by Dylan Bourgeois on 23/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "SettingsViewController.h"

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
    
    PFUser *user = [PFUser currentUser];
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:user.username];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
            
        } else {
            self.roomies = [object objectForKey:@"roommates"];
            NSLog(@"%@", self.roomies);
        }
    }];
    [self.tableView reloadData];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)inviteFriends:(id)sender {
}
- (IBAction)logout:(id)sender {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.userName.text = [self.userText uppercaseString];
    self.karma.text = self.userKarma;
    [self.tableView reloadData];
}
- (IBAction)edit:(id)sender {
    [self.tableView setEditing:YES animated:YES];
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
        UITextField * tx= [[UITextField alloc] initWithFrame:CGRectMake(15, cell.frame.origin.y+12, 185, 30)];
        tx.adjustsFontSizeToFitWidth = YES;
        tx.textColor = [UIColor whiteColor];
        tx.placeholder = @"Add a roommate !";
        tx.font = [UIFont fontWithName:@"Futura" size:24];
        tx.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        tx.autocorrectionType = UITextAutocorrectionTypeNo;
        [tx setEnabled:YES];
        [cell.contentView addSubview:tx];
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
        /* ============== REMOVE FROM PARSE AS WELL =============== */
        [self.roomies removeObjectAtIndex:indexPath.row];
        [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                  withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
