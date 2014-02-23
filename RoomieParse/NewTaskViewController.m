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
    
    // Trim comment and save it in a dictionary for use later in our callback block
    NSString *trimmedTask = [self.taskText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedUser = [self.taskAssign.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    PFObject*newTask = [PFObject objectWithClassName:@"Tasks"];
    
    
    newTask[@"taskId"]= trimmedTask;
    //Is user part of roommates ? OR uipicker OR autocomplete ?
    newTask[@"user"]=trimmedUser;
    // Is value > 0 ?
    newTask[@"karma"]=[NSNumber numberWithInt:(int)self.karmaStepper.value];
    //Is date after [NSDate date]
    newTask[@"dateLimit"]=self.datePick.date;
    
    [newTask saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    
    else if (sender.value < 0) {
        self.karmaValue.textColor = [UIColor colorWithRed:244./255
                                                    green:157./255
                                                     blue:25./255
                                                    alpha:1];
    }
    
    else self.karmaValue.textColor = [UIColor darkGrayColor];
}


- (IBAction)hoursSelection:(id)sender {
    if (self.hoursSelector.isOn) self.datePick.datePickerMode = UIDatePickerModeDateAndTime;
    else self.datePick.datePickerMode = UIDatePickerModeDate;
}


@end
