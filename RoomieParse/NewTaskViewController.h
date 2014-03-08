//
//  NewTaskViewController.h
//  RoomieParse
//
//  Created by Dylan Bourgeois on 19/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomieHeader.h"
#import "DOAutocompleteTextField.h"


@interface NewTaskViewController : UITableViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, FUIAlertViewDelegate>
/* ========== IBOutlets ==========*/

@property (strong, nonatomic) IBOutlet DOAutocompleteTextField * taskAssign;

@property (strong, nonatomic) IBOutlet UILabel                 * karmaValue;

@property (strong, nonatomic) IBOutlet UITextField             * taskText;

@property (strong, nonatomic) IBOutlet UIDatePicker            * datePick;

@property (strong, nonatomic) IBOutlet UIStepper               * karmaStepper;

@property (strong, nonatomic) IBOutlet UISwitch                * hoursSelector;

@property (strong, nonatomic) IBOutlet UIView                  * topView;

@property (strong, nonatomic) IBOutlet UIButton                * cancelButton;
@property (strong, nonatomic) IBOutlet UIButton                * saveButton;

/* ========== Class Properties ==========*/
@property (strong, nonatomic) NSMutableArray * array;

@property (strong, nonatomic) NSString*     stringReplace;

@end
