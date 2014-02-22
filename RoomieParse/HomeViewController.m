//
//  HomeViewController.m
//  RoomieParse
//
//  Created by Dylan Bourgeois on 22/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "HomeViewController.h"
#import "HMSegmentedControl/HMSegmentedControl.h"

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
    // Do any additional setup after loading the view.
    CGFloat yDelta;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        yDelta = 20.0f;
    } else {
        yDelta = 0.0f;
    }
    
    // Minimum code required to use the segmented control with the default styling.
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"All",@"Dylan", @"Tristan"]];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [segmentedControl setFrame:CGRectMake(0, 0 + yDelta+20, 320, 40)];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:segmentedControl];
    
    self.displayUser = @"all";
}

- (void)viewDidAppear:(BOOL)animated
{
    self.displayUser = @"all";
    
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            self.displayUser = @"all";
            [self loadObjects];
            break;
        case 1:
            self.displayUser = @"dylan";
            [self loadObjects];
            break;
            
        case 2:
            self.displayUser = @"tristan";
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
    
    // Configure the cell
    cell.textLabel.text = [object objectForKey:@"taskId"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"karma"]];
    
    /*UIView *cellBgView =[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300, [cell frame].size.height)];
    [cellBgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"highway-to-hipster-dream.jpg"]]];
    [cellBgView setFrame:CGRectMake(0.0f, 0.0f, 200,[cell frame].size.height )];

    [cell setBackgroundView:cellBgView];*/
    
    if ([[object objectForKey:@"karma"] intValue] > 0) {
        cell.detailTextLabel.textColor = [UIColor colorWithRed:150./255
                                                         green:210./255
                                                          blue:149./255
                                                         alpha:1];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@",[object objectForKey:@"karma"]];
    }
    
    else if ([[object objectForKey:@"karma"] intValue] < 0) {
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    else cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    if ([(NSDate*)[object objectForKey:@"dateLimit"] compare:[NSDate date]] == NSOrderedAscending)
    {
        cell.backgroundColor = [UIColor colorWithRed:244./255
                                               green:157./255
                                                blue:25./255
                                               alpha:1];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    
    else {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (PFQuery *)queryForTable {
    
    if ([PFUser currentUser]) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"Tasks"];
        
        if ([self.displayUser isEqualToString:@"all"])
        {
            // Finds scores from any of Jonathan, Dario, or Shawn
            NSArray *names = @[@"dylan",
                               @"tristan"];
            [query whereKey:@"user" containedIn:names];
        }
        else if (self.displayUser) [query whereKey:@"user" equalTo:self.displayUser];
        
        // If Pull To Refresh is enabled, query against the network by default.
        if (self.pullToRefreshEnabled) {
            query.cachePolicy = kPFCachePolicyNetworkOnly;
        }
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if (self.objects.count == 0) {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
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
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"Tasks";
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
        
    }
    return self;
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
