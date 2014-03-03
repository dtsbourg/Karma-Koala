//
//  HomeViewController.m
//  RoomieParse
//
//  Created by Dylan Bourgeois on 22/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    CGFloat yDelta;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        yDelta = 20.0f;
    } else {
        yDelta = 0.0f;
    }
    if(self.array ==nil) self.array =[[NSMutableArray alloc] initWithObjects:@"ALL", nil];
    else [self.array insertObject:@"ALL" atIndex:0];
    [self.array insertObject:[[PFUser currentUser].username uppercaseString] atIndex:1];
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.array];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.segmentedControl setFrame:CGRectMake(0, 0 + yDelta+30, 320, 40)];
    [self.segmentedControl setBackgroundColor:[UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1]];
    [self.segmentedControl setTextColor:[UIColor whiteColor]];
    [self.segmentedControl setSelectedTextColor:[UIColor colorWithRed:150./255 green:210./255 blue:149./255 alpha:1]];
    self.segmentedControl.selectionIndicatorColor= [UIColor colorWithRed:150./255 green:210./255 blue:149./255 alpha:1];
    [self.segmentedControl setFont:[UIFont fontWithName:@"Futura" size:18]];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.segmentedControl];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            self.displayUser = [self.array objectAtIndex:0];
            [self loadObjects];
            break;
        case 1:
            self.displayUser = [self.array objectAtIndex:1];
            [self loadObjects];
            break;
            
        case 2:
            self.displayUser = [self.array objectAtIndex:2];
            [self loadObjects];
            break;
        case 3:
            self.displayUser = [self.array objectAtIndex:3];
            [self loadObjects];
            break;
        case 4:
            self.displayUser = [self.array objectAtIndex:4];
            [self loadObjects];
            break;
        case 5:
            self.displayUser = [self.array objectAtIndex:5];
            [self loadObjects];
            break;
        case 6:
            self.displayUser = [self.array objectAtIndex:6];
            [self loadObjects];
            break;
        case 7:
            self.displayUser = [self.array objectAtIndex:7];
            [self loadObjects];
            break;
        case 8:
            self.displayUser = [self.array objectAtIndex:8];
            [self loadObjects];
            break;
        case 9:
            self.displayUser = [self.array objectAtIndex:9];
            [self loadObjects];
            break;
            
        default:
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"Cell";
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    cell.backgroundColor = [UIColor colorWithRed:83./255 green:38./255 blue:64./255 alpha:1];
    
        cell.textLabel.text = [object objectForKey:@"taskId"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"karma"]];
        
    if ([(NSDate*)[object objectForKey:@"dateLimit"] compare:[NSDate date]] == NSOrderedAscending)
    {
        cell.textLabel.textColor = [UIColor colorWithRed:244./255
                                                    green:157./255
                                                    blue:25./255
                                                    alpha:1];
    }
    
    else cell.textLabel.textColor = [UIColor whiteColor];
    
    if ([cell.detailTextLabel.text intValue] > 0) {
        cell.detailTextLabel.textColor = [UIColor colorWithRed:150./255
                                                         green:210./255
                                                          blue:149./255
                                                         alpha:1];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@",[object objectForKey:@"karma"]];
    }
    
    else if ([cell.detailTextLabel.text intValue] < 0) {
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    else cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Futura" size:24]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Futura" size:20]];
    cell.userInteractionEnabled = NO;
    
    return cell;
}

- (PFQuery *)queryForTable {
    
    if ([PFUser currentUser]) {
    
        PFQuery *query = [PFQuery queryWithClassName:@"Tasks"];
        Reachability* reach = [Reachability reachabilityForInternetConnection];
        
        if ([self.displayUser isEqualToString:@"ALL"])
        {
            NSMutableArray *names = [self.array mutableCopy];
            [names addObject:[[PFUser currentUser].username uppercaseString]];

            [query whereKey:@"user" containedIn:names];
        }
        
        else if (self.displayUser) [query whereKey:@"user" equalTo:self.displayUser];
        
        if(![reach isReachable]) {
            if (self.pullToRefreshEnabled) {
                query.cachePolicy = kPFCachePolicyCacheElseNetwork ;
            }
            // If no objects are loaded in memory, we look to the cache first to fill the table
            // and then subsequently do a query against the network.
            if (self.objects.count == 0) {
                query.cachePolicy = kPFCachePolicyCacheElseNetwork ;
            }
        }
        
        else {
            if (self.pullToRefreshEnabled) {
                query.cachePolicy = kPFCachePolicyCacheThenNetwork ;
            }
            // If no objects are loaded in memory, we look to the cache first to fill the table
            // and then subsequently do a query against the network.
            if (self.objects.count == 0) {
                query.cachePolicy = kPFCachePolicyNetworkElseCache ;
            }
            
            query.cachePolicy = kPFCachePolicyCacheThenNetwork ;
        }
        
        return query;
    }

    else return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Tasks";
        // The number of objects to show per page
        self.objectsPerPage = 15;
        
    }
    return self;
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
