//
//  NewTaskViewController.m
//  RoomieParse
//
//  Created by Dylan Bourgeois on 19/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "NewTaskViewController.h"

@interface NewTaskViewController ()

@end

@implementation NewTaskViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.hoursSelector.on = YES;
    
    self.taskAssign.delegate = self;
    self.taskText.delegate = self;
    
    PFUser *user = [PFUser currentUser];
    // Do any additional setup after loading the view.
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:user.username];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            self.array = [object objectForKey:@"roommates"];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
    
}

- (IBAction)save:(id)sender {
    //TODO Data is complete verifications
    BOOL err= NO;
    // Trim comment and save it in a dictionary for use later in our callback block
    NSString *trimmedTask = [self.taskText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedUser = [self.taskAssign.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //Is user part of roommates ? OR uipicker OR autocomplete ?
    if (![self.array containsObject:trimmedUser])
    {
        if ([trimmedUser length] > 0) {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                         message:[NSString stringWithFormat:@"Sorry, %@ is not part of your home ! Add him and try again !", trimmedUser]
                                                        delegate:self
                                               cancelButtonTitle:@"Try again"
                                               otherButtonTitles:nil];
            [al show];
        }
        
        else {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                         message:@"The roomate field is empty !"
                                                        delegate:self
                                               cancelButtonTitle:@"Try again"
                                               otherButtonTitles:nil];
            [al show];
        }
        err=YES;
    }
    
    else if ([trimmedTask length] == 0) {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                     message:@"The task field is empty !"
                                                    delegate:self
                                           cancelButtonTitle:@"Try again"
                                           otherButtonTitles:nil];
        [al show];
        err=YES;

    }
    
    else if ([NSNumber numberWithInt:(int)self.karmaStepper.value] < 0)
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                     message:@"Sorry, the karma value must be superior to 0"
                                                    delegate:self
                                           cancelButtonTitle:@"Try again"
                                           otherButtonTitles:nil];
        [al show];
        err=YES;
    }
    else if ([self.datePick.date compare:[NSDate date]] == NSOrderedAscending)
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                     message:@"Sorry, this is not a valid date."
                                                    delegate:self
                                           cancelButtonTitle:@"Try again"
                                           otherButtonTitles:nil];
        [al show];
        err=YES;
    }
    
    
    if (!err) {
        PFObject*newTask = [PFObject objectWithClassName:@"Tasks"];
        newTask[@"taskId"]= trimmedTask;
        newTask[@"user"]=trimmedUser;
        newTask[@"karma"]=[NSNumber numberWithInt:(int)self.karmaStepper.value];
        newTask[@"dateLimit"]=self.datePick.date;
    
        [newTask saveInBackground];
         [self dismissViewControllerAnimated:YES completion:nil];
    }
    
   
    
}


- (IBAction)stepper:(UISlider*)sender {
    self.karmaValue.text = [NSString stringWithFormat:@"%i", (int)sender.value];
    if (sender.value > 0) {
        self.karmaValue.textColor = [UIColor colorWithRed:150./255
                                                    green:210./255
                                                     blue:149./255
                                                    alpha:1];
        self.karmaValue.text = [NSString stringWithFormat:@"+%i", (int)sender.value];
    }
    
    else self.karmaValue.textColor = [UIColor darkGrayColor];
}

- (IBAction)hoursSelection:(id)sender {
    if (self.hoursSelector.isOn) self.datePick.datePickerMode = UIDatePickerModeDateAndTime;
    else self.datePick.datePickerMode = UIDatePickerModeDate;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.taskAssign) {
        [self.taskText becomeFirstResponder];
        return YES;
    }
    
    else {
        [textField resignFirstResponder];
        return NO;
    }
    
}


@end
