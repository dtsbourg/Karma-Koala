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
    
    [self.topView addSubview:self.saveButton];
    [self.topView addSubview:self.cancelButton];
    
    self.navigationController.navigationBar.hidden = YES;
    self.hoursSelector.on                          = YES;
    
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    
    PFUser *user = [PFUser currentUser];

    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[user.username uppercaseString]];
    if(![reach isReachable]) query.cachePolicy = kPFCachePolicyCacheElseNetwork ;
    else query.cachePolicy = kPFCachePolicyCacheThenNetwork ;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.array = [object objectForKey:@"roommates"];
        [self.array addObject:[user.username uppercaseString]];
    }];
    
    self.taskAssign.delegate               = self;
    self.taskAssign.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.taskText.delegate                 = self;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.taskText.leftView = paddingView;
    self.taskText.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingViewAssign = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.taskAssign.leftView = paddingViewAssign;
    self.taskAssign.leftViewMode = UITextFieldViewModeAlways;
    [self.taskAssign setTintColor:[UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1]];
    [self.taskText setTintColor:[UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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

#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    BOOL err= NO;
    // Trim comment and save it in a dictionary for use later in our callback block
    NSString *trimmedTask = [self.taskText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedUser = [self.taskAssign.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![self.array containsObject:trimmedUser])
    {
        if ([trimmedUser length] > 0) {
            [self.view endEditing:YES];
            FUIAlertView *al                      = [[FUIAlertView alloc] initWithTitle:@"Oops!"
                                                                                message:[NSString stringWithFormat:@"Sorry, %@ is not part of your home ! Add him and try again !", trimmedUser]
                                                                               delegate:self
                                                                      cancelButtonTitle:@"Try again"
                                                                      otherButtonTitles:nil];

            al.titleLabel.textColor               = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
            al.titleLabel.font                    = [UIFont fontWithName:@"Futura" size:20];
            al.messageLabel.textColor             = [UIColor cloudsColor];
            al.messageLabel.font                  = [UIFont fontWithName:@"Futura" size:20];
            al.backgroundOverlay.backgroundColor  = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:0.7];
            al.alertContainer.backgroundColor     = [UIColor colorWithRed:83./255 green:38./255 blue:64./255 alpha:1];
            al.defaultButtonColor                 = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1];
            al.defaultButtonShadowColor           = [UIColor clearColor];
            al.defaultButtonFont                  = [UIFont fontWithName:@"Futura" size:20];
            al.defaultButtonTitleColor            = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
            al.alertContainer.layer.cornerRadius  = 5;
            al.alertContainer.layer.masksToBounds = YES;
            [al show];
        }
        
        else {
            [self.view endEditing:YES];
            FUIAlertView *al                      = [[FUIAlertView alloc] initWithTitle:@"Oops!"
                                                                                message:@"The roomate field is empty !"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"Try again"
                                                                      otherButtonTitles:nil];
            al.titleLabel.textColor               = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
            al.titleLabel.font                    = [UIFont fontWithName:@"Futura" size:20];
            al.messageLabel.textColor             = [UIColor cloudsColor];
            al.messageLabel.font                  = [UIFont fontWithName:@"Futura" size:20];
            al.backgroundOverlay.backgroundColor  = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:0.7];
            al.alertContainer.backgroundColor     = [UIColor colorWithRed:83./255 green:38./255 blue:64./255 alpha:1];
            al.defaultButtonColor                 = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1];
            al.defaultButtonShadowColor           = [UIColor clearColor];
            al.defaultButtonFont                  = [UIFont fontWithName:@"Futura" size:20];
            al.defaultButtonTitleColor            = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
            al.alertContainer.layer.cornerRadius  = 5;
            al.alertContainer.layer.masksToBounds = YES;
            
            [al show];
        }
        err=YES;
    }
    
    else if ([trimmedTask length] == 0) {
        [self.view endEditing:YES];
        FUIAlertView *al                      = [[FUIAlertView alloc] initWithTitle:@"Oops!"
                                                                            message:@"The task field is empty !"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Try again"
                                                                  otherButtonTitles:nil];
        al.titleLabel.textColor               = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
        al.titleLabel.font                    = [UIFont fontWithName:@"Futura" size:20];
        al.messageLabel.textColor             = [UIColor cloudsColor];
        al.messageLabel.font                  = [UIFont fontWithName:@"Futura" size:20];
        al.backgroundOverlay.backgroundColor  = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:0.7];
        al.alertContainer.backgroundColor     = [UIColor colorWithRed:83./255 green:38./255 blue:64./255 alpha:1];
        al.defaultButtonColor                 = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1];
        al.defaultButtonShadowColor           = [UIColor clearColor];
        al.defaultButtonFont                  = [UIFont fontWithName:@"Futura" size:20];
        al.defaultButtonTitleColor            = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
        al.alertContainer.layer.cornerRadius  = 5;
        al.alertContainer.layer.masksToBounds = YES;
        [al show];
        err=YES;

    }
    
    else if ([NSNumber numberWithInt:(int)self.karmaStepper.value] < 0)
    {
        [self.view endEditing:YES];
        FUIAlertView *al                      = [[FUIAlertView alloc] initWithTitle:@"Oops!"
                                                                            message:@"Must. Not. Divide. By. Zero."
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Try again"
                                                                  otherButtonTitles:nil];
        al.titleLabel.textColor               = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
        al.titleLabel.font                    = [UIFont fontWithName:@"Futura" size:20];
        al.messageLabel.textColor             = [UIColor cloudsColor];
        al.messageLabel.font                  = [UIFont fontWithName:@"Futura" size:20];
        al.backgroundOverlay.backgroundColor  = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:0.7];
        al.alertContainer.backgroundColor     = [UIColor colorWithRed:83./255 green:38./255 blue:64./255 alpha:1];
        al.defaultButtonColor                 = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1];
        al.defaultButtonShadowColor           = [UIColor clearColor];
        al.defaultButtonFont                  = [UIFont fontWithName:@"Futura" size:20];
        al.defaultButtonTitleColor            = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
        al.alertContainer.layer.cornerRadius  = 5;
        al.alertContainer.layer.masksToBounds = YES;
        [al show];
        err=YES;
    }
    else if ([self.datePick.date compare:[NSDate date]] == NSOrderedAscending)
    {
        [self.view endEditing:YES];
        FUIAlertView *al                      = [[FUIAlertView alloc] initWithTitle:@"Oops!"
                                                                            message:@"Great Scott ! Please enter a date in the future !"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Try again"
                                                                  otherButtonTitles:nil];
        al.titleLabel.textColor               = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
        al.titleLabel.font                    = [UIFont fontWithName:@"Futura" size:20];
        al.messageLabel.textColor             = [UIColor cloudsColor];
        al.messageLabel.font                  = [UIFont fontWithName:@"Futura" size:20];
        al.backgroundOverlay.backgroundColor  = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:0.7];
        al.alertContainer.backgroundColor     = [UIColor colorWithRed:83./255 green:38./255 blue:64./255 alpha:1];
        al.defaultButtonColor                 = [UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1];
        al.defaultButtonShadowColor           = [UIColor clearColor];
        al.defaultButtonFont                  = [UIFont fontWithName:@"Futura" size:20];
        al.defaultButtonTitleColor            = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
        al.alertContainer.layer.cornerRadius  = 5;
        al.alertContainer.layer.masksToBounds = YES;
        [al show];
        err=YES;
    }
    
    
    if (!err) {
        PFObject*newTask        = [PFObject objectWithClassName:@"Tasks"];
        newTask[@"taskId"]      = trimmedTask;
        newTask[@"user"]        = trimmedUser;
        newTask[@"karma"]       = [NSNumber numberWithInt:(int)self.karmaStepper.value];
        newTask[@"dateLimit"]   = self.datePick.date;
        
        Reachability* reach = [Reachability reachabilityForInternetConnection];
        if([reach isReachable]) [newTask saveInBackground];
        else [newTask saveEventually];
        
        // Build a query to match user
        PFQuery *innerQuery = [PFUser query];
        
        // Use hasPrefix: to only match against the month/date
        [innerQuery whereKey:@"username" equalTo:trimmedUser];
        
        // Build the actual push notification target query
        PFQuery *queryo = [PFInstallation query];
        
        // only return Installations that belong to a User that
        // matches the innerQuery
        [queryo whereKey:@"user" matchesQuery:innerQuery];
        [queryo whereKey:@"deviceType" equalTo:@"ios"];
        
        // Send the notification.
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:queryo];
        [push setMessage:[NSString stringWithFormat:@"%@ added a task for you to do : %@.",[PFUser currentUser].username, trimmedTask]];
        [push sendPushInBackground];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


- (IBAction)stepper:(UIStepper*)sender {
    if (sender.value > 0) {
        self.karmaValue.textColor = [UIColor colorWithRed:150./255
                                                    green:210./255
                                                     blue:149./255
                                                    alpha:1];
        self.karmaValue.text      = [NSString stringWithFormat:@"+%i", (int)sender.value];
    }
    
    else
    {
        self.karmaValue.textColor = [UIColor darkGrayColor];
        self.karmaValue.text      = [NSString stringWithFormat:@"%i", (int)sender.value];
    }
}

- (IBAction)hoursSelection:(id)sender {
    if (self.hoursSelector.isOn) self.datePick.datePickerMode = UIDatePickerModeDateAndTime;
    else                         self.datePick.datePickerMode = UIDatePickerModeDate;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.taskAssign) {
        if (self.stringReplace) {
            self.taskAssign.text = self.stringReplace;
        }
        
        [self.taskText becomeFirstResponder];
        return YES;
    }
    
    else {
        [textField resignFirstResponder];
        return NO;
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect fixedFrame = self.topView.frame;
    fixedFrame.origin.y = 0 + scrollView.contentOffset.y;
    self.topView.frame = fixedFrame;
}

- (NSString *)textField:(DOAutocompleteTextField *)textField completionForPrefix:(NSString *)prefix
{
    NSArray *autocompleteArray = self.array;
    
    for (NSString *string in autocompleteArray)
    {
        if([string hasPrefix:prefix])
        {
            self.stringReplace = string;
            return [string stringByReplacingCharactersInRange:[prefix rangeOfString:prefix] withString:@""];
        }
        
    }
    return @"";
}


@end
