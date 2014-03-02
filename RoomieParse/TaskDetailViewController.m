//
//  TaskDetailViewController.m
//  RoomieParse
//
//  Created by Dylan Bourgeois on 20/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "EFCircularSlider.h"


@interface TaskDetailViewController () {
EFCircularSlider* minuteSlider;
EFCircularSlider* hourSlider;
    int delayHour;
    int delayMinute;
}
@end

@implementation TaskDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    
    [self.view addSubview:self.daysLate];
    [self.daysLate setTitleColor:[UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1] forState:UIControlStateNormal];
    self.daysLate.userInteractionEnabled=NO;
    
    float y=0;
    
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        y=25;
    } else {
        y=0;
    }
    
    
    CGRect minuteSliderFrame = CGRectMake(30+y/2., 185+y/3., 260-y, 260-y);
    minuteSlider = [[EFCircularSlider alloc] initWithFrame:minuteSliderFrame];
    minuteSlider.unfilledColor = [UIColor colorWithRed:23/255.0f
                                                 green:47/255.0f
                                                  blue:70/255.0f
                                                 alpha:1.0f];
    
    minuteSlider.filledColor = [UIColor colorWithRed:155/255.0f
                                               green:211/255.0f
                                                blue:156/255.0f
                                               alpha:1.0f];
    
    [minuteSlider setInnerMarkingLabels:@[@"5", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55", @"60"]];
    minuteSlider.labelFont = [UIFont systemFontOfSize:14.0f];
    minuteSlider.lineWidth = 8;
    minuteSlider.snapToLabels = NO;
    minuteSlider.minimumValue = 0;
    minuteSlider.maximumValue = 60;
    minuteSlider.labelColor = [UIColor colorWithRed:76/255.0f
                                              green:111/255.0f
                                               blue:137/255.0f
                                              alpha:1.0f];
    
    minuteSlider.handleType = EFDoubleCircleWithOpenCenter;
    minuteSlider.handleColor = minuteSlider.filledColor;
    [minuteSlider addTarget:self action:@selector(minutesValueChanged:) forControlEvents:UIControlEventValueChanged];
    minuteSlider.userInteractionEnabled = NO;
    [self.view addSubview:minuteSlider];
    
    CGRect hourSliderFrame = CGRectMake(80, 230, 160, 160);
    hourSlider = [[EFCircularSlider alloc] initWithFrame:hourSliderFrame];
    hourSlider.unfilledColor = [UIColor colorWithRed:23/255.0f
                                               green:47/255.0f
                                                blue:70/255.0f
                                               alpha:1.0f];
    
    hourSlider.filledColor = [UIColor colorWithRed:98/255.0f
                                             green:243/255.0f
                                              blue:252/255.0f
                                             alpha:1.0f];
    
    [hourSlider setInnerMarkingLabels:@[ @"2", @"4", @"6",@"8",@"10",@"12", @"14",@"16",@"18", @"20",@"22",@"0" ]];
    hourSlider.labelFont = [UIFont systemFontOfSize:14.0f];
    hourSlider.lineWidth = 12;
    hourSlider.snapToLabels = NO;
    hourSlider.minimumValue = 0;
    hourSlider.maximumValue = 24;
    hourSlider.labelColor = [UIColor colorWithRed:127/255.0f
                                            green:229/255.0f
                                             blue:255/255.0f
                                            alpha:1.0f];
    
    hourSlider.handleType = EFBigCircle;
    hourSlider.handleColor = hourSlider.filledColor;
    
    [hourSlider addTarget:self action:@selector(hoursValueChanged:) forControlEvents:UIControlEventValueChanged];
    hourSlider.userInteractionEnabled = NO;
    [self.view addSubview:hourSlider];
    
    // Do any additional setup after loading the view.
    self.taskName.text = self.taskText;
    self.karma.text = self.taskKarma;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Tasks"];
    [query whereKey:@"user" equalTo:[PFUser currentUser].username];
    [query whereKey:@"taskId" equalTo:self.taskText];
    if(![reach isReachable]) query.cachePolicy = kPFCachePolicyCacheElseNetwork ;
    else query.cachePolicy = kPFCachePolicyCacheThenNetwork ;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            
            self.dueDate = [object objectForKey:@"dateLimit"];
            NSDate *now = [NSDate date];
            NSTimeInterval secondsBetween = [self.dueDate timeIntervalSinceDate:now];
            
            int numberOfDays = secondsBetween / 86400;
            int numberOfHours = secondsBetween / 3600;
            int numberOfMinutes = secondsBetween / 60;
            
        [minuteSlider setCurrentValue:abs(numberOfMinutes%60) ];
    
        [hourSlider setCurrentValue:abs(numberOfHours%24)];
            
        if (secondsBetween > 0) {
            if (numberOfDays) {
                self.timeLeft.text = [NSString stringWithFormat:@"%i %@ , %i %@ and %i %@ left !", numberOfDays, (numberOfDays == 1) ? @"day" : @"days", numberOfHours%24, (numberOfHours%24 == 1) ? @"hour" : @"hours", numberOfMinutes%60, (numberOfMinutes%60 == 1) ? @"minute" : @"minutes" ];
                [self.daysLate setTitle:[NSString stringWithFormat:@"%i", numberOfDays] forState:UIControlStateNormal ];
            } else {
                if (numberOfHours) {
                    self.timeLeft.text = [NSString stringWithFormat:@"%i %@ and %i %@ left !",numberOfHours%24,(numberOfHours%24 == 1) ? @"hour" : @"hours", numberOfMinutes%60, (numberOfMinutes%60 == 1) ? @"minute" : @"minutes"];
                } else {
                    self.timeLeft.text = [NSString stringWithFormat:@"%i %@ left !",numberOfMinutes%60, (numberOfMinutes%60 == 1) ? @"minute" : @"minutes"];
                }
            }
        }
            
            else {
                if (numberOfDays) {
                    self.timeLeft.text = [NSString stringWithFormat:@"%i %@ , %i %@ and %i %@ late !", abs(numberOfDays), (abs(numberOfDays) == 1) ? @"day" : @"days", abs(numberOfHours%24),(abs(numberOfHours%24) == 1) ? @"hour" : @"hours", abs(numberOfMinutes%60), (abs(numberOfMinutes%60) == 1) ? @"minute" : @"minutes"];
                    [self.daysLate setTitle:[NSString stringWithFormat:@"%i", abs(numberOfDays)] forState:UIControlStateNormal ];
                } else {
                    if (numberOfHours) {
                        self.timeLeft.text = [NSString stringWithFormat:@"%i %@ and %i %@ late !",abs(numberOfHours%24),(abs(numberOfHours%24) == 1) ? @"hour" : @"hours", abs(numberOfMinutes%60), (abs(numberOfMinutes%60) == 1) ? @"minute" : @"minutes"];
                    } else {
                        self.timeLeft.text = [NSString stringWithFormat:@"%i %@ late !",abs(numberOfMinutes%60), (abs(numberOfMinutes%60) == 1) ? @"minute" : @"minutes"];
                    }
                    
                }

            }
        }
    }];
    
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        self.taskName.frame = CGRectMake(self.taskName.frame.origin.x, self.taskName.frame.origin.y - 30, self.taskName.frame.size.width, self.taskName.frame.size.height);
       
        self.karma.frame = CGRectMake(self.karma.frame.origin.x, self.karma.frame.origin.y - 30, self.karma.frame.size.width, self.karma.frame.size.height);
        
        self.timeLeft.frame = CGRectMake(self.timeLeft.frame.origin.x, self.timeLeft.frame.origin.y - 50, self.timeLeft.frame.size.width, self.timeLeft.frame.size.height);
        
        self.daysLate.frame = CGRectMake(self.daysLate.frame.origin.x, self.daysLate.frame.origin.y - 65, self.daysLate.frame.size.width, self.daysLate.frame.size.height);
        
        minuteSlider.frame = CGRectMake(minuteSlider.frame.origin.x, minuteSlider.frame.origin.y - 65, minuteSlider.frame.size.width, minuteSlider.frame.size.height);
        hourSlider.frame = CGRectMake(hourSlider.frame.origin.x, hourSlider.frame.origin.y - 65, hourSlider.frame.size.width,hourSlider.frame.size.height);
        
        self.buttonDelay.frame = CGRectMake(self.buttonDelay.frame.origin.x, self.buttonDelay.frame.origin.y - 88, self.buttonDelay.frame.size.width, self.buttonDelay.frame.size.height);
        
        self.buttonComplete.frame = CGRectMake(self.buttonComplete.frame.origin.x, self.buttonComplete.frame.origin.y - 88, self.buttonComplete.frame.size.width, self.buttonComplete.frame.size.height);
    }
    
}

-(void)hoursValueChanged:(EFCircularSlider*)slider {
    delayHour = slider.currentValue;
}

-(void)minutesValueChanged:(EFCircularSlider*)slider {
    delayMinute = slider.currentValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)taskIsCompleted:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[user.username uppercaseString]];
    
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    if(![reach isReachable]) query.cachePolicy = kPFCachePolicyCacheElseNetwork ;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            [object incrementKey:@"karma"
                        byAmount:[NSNumber numberWithInt:[self.taskKarma intValue]]];

            if([reach isReachable]) [object saveInBackground];
            else [object saveEventually];
        }
    }];
    
    PFQuery *queryTask = [PFQuery queryWithClassName:@"Tasks"];
    if(![reach isReachable]) queryTask.cachePolicy = kPFCachePolicyCacheElseNetwork ;
    else queryTask.cachePolicy = kPFCachePolicyCacheThenNetwork ;
    [queryTask whereKey:@"user" equalTo:[PFUser currentUser].username];
    [queryTask whereKey:@"taskId" equalTo:self.taskText];
    

    [queryTask getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (object) {
            if([reach isReachable]) [object deleteInBackground];
            else [object deleteEventually];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)delayTask:(id)sender {
    
    hourSlider.snapToLabels = YES;
    minuteSlider.userInteractionEnabled = YES;
    hourSlider.userInteractionEnabled = YES;
    [minuteSlider setCurrentValue:0];
    [hourSlider setCurrentValue:0];
    
    self.daysLate.userInteractionEnabled = YES;
    [self.daysLate setTitle:[NSString stringWithFormat:@"%i", self.delayDay] forState:UIControlStateNormal];
    [self.view addSubview:self.daysLate];
    [self.daysLate setTitleColor:[UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1] forState:UIControlStateNormal];
    
    self.timeLeft.hidden = YES;
    
    float y=0;
    if ([UIScreen mainScreen].bounds.size.height < 568) y=65;
    UIButton *confirm = [[UIButton alloc]initWithFrame:CGRectMake(20, 134-y, 280, 42)];
    
    
    [confirm setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirm setBackgroundColor:[UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1]];
    [confirm setTitleColor:[UIColor colorWithRed:150./255 green:210./255 blue:149./255 alpha:1] forState:UIControlStateNormal];
    [confirm.titleLabel setFont:[UIFont fontWithName:@"Futura" size:16]];
    [confirm addTarget:self
               action:@selector(confirm:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirm];
}

-(IBAction)dayValueIncr:(UIButton*)sender{
    self.delayDay = self.delayDay + 1;
    [self.daysLate setTitle:[NSString stringWithFormat:@"%i", self.delayDay] forState:UIControlStateNormal ];
    if (self.delayDay > 9) [self.daysLate.titleLabel setFont:[UIFont fontWithName:@"Futura" size:40]];
}

-(void)confirm:(UIButton*)sender {
    PFUser *user = [PFUser currentUser];
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[user.username uppercaseString]];
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    if(![reach isReachable]) query.cachePolicy = kPFCachePolicyCacheElseNetwork ;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
        } else {
            Reachability* reach = [Reachability reachabilityForInternetConnection];
            
            int karmaDelay = (int) - [self.taskKarma intValue]/2. ;
            [object incrementKey:@"karma" byAmount:[NSNumber numberWithInt:karmaDelay]];
            
            if([reach isReachable]) [object saveInBackground];
            else [object saveEventually];
        }
    }];
    
    PFQuery *queryTask = [PFQuery queryWithClassName:@"Tasks"];
    [queryTask whereKey:@"user" equalTo:[PFUser currentUser].username];
    [queryTask whereKey:@"taskId" equalTo:self.taskText];
    if(![reach isReachable]) queryTask.cachePolicy = kPFCachePolicyCacheElseNetwork ;
    [queryTask getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
        } else {
            Reachability* reach = [Reachability reachabilityForInternetConnection];
            [object setObject:[self.dueDate dateByAddingTimeInterval:(self.delayDay*24 + delayHour*3600 + delayMinute*60)] forKey:@"dateLimit"];
            
            if([reach isReachable]) [object saveInBackground];
            else [object saveEventually];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}



@end
