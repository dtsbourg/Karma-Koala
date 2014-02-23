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
    //int delayDay;
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
    
    self.daysLate.userInteractionEnabled=NO;
    
    CGRect minuteSliderFrame = CGRectMake(30, 185, 260, 260);
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
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            self.dueDate = [object objectForKey:@"dateLimit"];
            NSDate *now = [NSDate date];
            NSTimeInterval secondsBetween = [self.dueDate timeIntervalSinceDate:now];
            
            int numberOfDays = secondsBetween / 86400;
            int numberOfHours = secondsBetween / 3600;
            int numberOfMinutes = secondsBetween / 60;
            
           [ minuteSlider setCurrentValue:abs(numberOfMinutes%60) ];
            [hourSlider setCurrentValue:abs(numberOfHours%60)];
            
            if (secondsBetween > 0) {
            if (numberOfDays) {
                self.timeLeft.text = [NSString stringWithFormat:@"%i days , %i hours and %i minutes left !", numberOfDays, numberOfHours%24, numberOfMinutes%60];
                [self.daysLate setTitle:[NSString stringWithFormat:@"%i", numberOfDays] forState:UIControlStateNormal ];
            } else {
                if (numberOfHours) {
                    self.timeLeft.text = [NSString stringWithFormat:@"%ih and %im left !",numberOfHours%24, numberOfMinutes%60];
                } else {
                    self.timeLeft.text = [NSString stringWithFormat:@"%i minutes left !",numberOfMinutes%60];
                }
                
            }
            }
            
            else {
                if (numberOfDays) {
                    self.timeLeft.text = [NSString stringWithFormat:@"%i days , %i hours and %i minutes late !", abs(numberOfDays), abs(numberOfHours%24), abs(numberOfMinutes%60)];
                    [self.daysLate setTitle:[NSString stringWithFormat:@"%i", abs(numberOfDays)] forState:UIControlStateNormal ];
                } else {
                    if (numberOfHours) {
                        self.timeLeft.text = [NSString stringWithFormat:@"%i hours and %i minutes late !",abs(numberOfHours%24), abs(numberOfMinutes%60)];
                    } else {
                        self.timeLeft.text = [NSString stringWithFormat:@"%i minutes late !",abs(numberOfMinutes%60)];
                    }
                    
                }

            }
        }
    }];
}

-(void)hoursValueChanged:(EFCircularSlider*)slider {
    delayHour = slider.currentValue;
    NSLog(@"%i", delayHour);
}

-(void)minutesValueChanged:(EFCircularSlider*)slider {
    delayMinute = slider.currentValue;
    NSLog(@"%i", delayMinute);
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
    [query whereKey:@"username" equalTo:user.username];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            [object incrementKey:@"karma"
                        byAmount:[NSNumber numberWithInt:[self.taskKarma intValue]]];
            [object saveInBackground];
        }
    }];
    
    PFQuery *queryTask = [PFQuery queryWithClassName:@"Tasks"];
    [queryTask whereKey:@"user" equalTo:[PFUser currentUser].username];
    [queryTask whereKey:@"taskId" equalTo:self.taskText];
    
    [queryTask getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) [object deleteInBackground];
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
//    CALayer *mainViewLayer = self.view.layer;
//    [mainViewLayer addSublayer:self.daysLate.layer];
    //[self.view insertSubview:self.daysLate aboveSubview:minuteSlider];
    self.daysLate.titleLabel.textColor = [UIColor colorWithRed:244./255 green:157./255 blue:25./255 alpha:1];
    
    self.timeLeft.hidden = YES;
        
    UIButton *confirm = [[UIButton alloc]initWithFrame:CGRectMake(20, 134, 280, 42)];
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
}

-(void)confirm:(UIButton*)sender {
    PFUser *user = [PFUser currentUser];
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:user.username];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            int karmaDelay = (int) - [self.taskKarma intValue]/2. ;
            [object incrementKey:@"karma" byAmount:[NSNumber numberWithInt:karmaDelay]];
            [object saveInBackground];
        }
    }];
    
    PFQuery *queryTask = [PFQuery queryWithClassName:@"Tasks"];
    [queryTask whereKey:@"user" equalTo:[PFUser currentUser].username];
    [queryTask whereKey:@"taskId" equalTo:self.taskText];
    
    [queryTask getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            
            // The find succeeded.
            NSLog(@"%i %i", delayHour, delayMinute);
            [object setObject:[self.dueDate dateByAddingTimeInterval:(self.delayDay*24 + delayHour*3600 + delayMinute*60)] forKey:@"dateLimit"];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
