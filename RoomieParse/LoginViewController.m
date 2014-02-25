//
//  LoginViewController.m
//  RoomieParse
//
//  Created by Dylan Bourgeois on 19/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [self.logInView setBackgroundColor:[UIColor colorWithRed:83./255 green:38./255 blue:64./255 alpha:1]];
    [self.logInView setLogo:nil];
    [self.logInView setTintColor:[UIColor whiteColor]];

    [self.logInView.usernameField setBackgroundColor:[UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1]];
    [self.logInView.passwordField setBackgroundColor:[UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1]];
    
    [self.logInView.usernameField setTextColor:[UIColor whiteColor]];
    [self.logInView.passwordField setTextColor:[UIColor whiteColor]];
    
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karma.png"]]];
    
    [self.logInView.signUpButton setImage:[UIImage imageNamed:@"purple_signup.png"] forState:UIControlStateNormal];
    
    [self.logInView.signUpButton setTitleColor:[UIColor colorWithRed:150./255 green:210./255 blue:149./255 alpha:1]
                                     forState:UIControlStateNormal];
}

-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
   [self setFontFamily:@"Futura" forView:view andSubViews:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
[self.logInView.logInButton setImage:[UIImage imageNamed:@"purple.png"] forState:UIControlStateNormal];
    
    UIColor *color = [UIColor colorWithWhite:1 alpha:0.7];
    UIFont *font = [UIFont fontWithName:@"Futura" size:20];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName, nil];
    
    self.logInView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:attrsDictionary];
    self.logInView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:attrsDictionary];
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
