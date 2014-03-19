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
    
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];
    
    [self.logInView setBackgroundColor:PURPLE_LIGHT];
    
    [self.logInView setTintColor:WHITE];

    [self.logInView.usernameField setBackgroundColor:PURPLE_DARK];
    
    [self.logInView.passwordField setBackgroundColor:PURPLE_DARK];
    
    [self.logInView.usernameField setTextColor:WHITE];
    [self.logInView.passwordField setTextColor:WHITE];
    
    self.logInView.usernameField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;

    CALayer *layer      = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer               = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"koala.png"]]];
    
    
    if ([UIScreen mainScreen].bounds.size.height < 568)
        [self.logInView.logo setFrame:CGRectMake(self.logInView.logo.frame.origin.x,
                                                 self.logInView.logo.frame.origin.y,
                                                 self.logInView.logo.frame.size.width -190,
                                                 self.logInView.logo.frame.size.height-190)];
    
    else [self.logInView.logo setFrame:CGRectMake(self.logInView.logo.frame.origin.x,
                                                  self.logInView.logo.frame.origin.y,
                                                  self.logInView.logo.frame.size.width -120,
                                                  self.logInView.logo.frame.size.height-120)];
    
    [self.logInView.signUpButton setImage:[UIImage imageNamed:@"purple_signup.png"] forState:UIControlStateNormal];
    
    [self.logInView.signUpButton setTitleColor:GREEN
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
    
    [self.logInView.passwordForgottenButton setBackgroundImage:[UIImage imageNamed:@"forgot.png"] forState:UIControlStateNormal];

}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if(![reach isReachable]) {
        FUIAlertView *al                      = [[FUIAlertView alloc] initWithTitle:@"Oops!"
                                                                            message:[NSString stringWithFormat:@"You aren't connected to Internet at the moment. Get a life, go outside !"]
                                                                           delegate:self
                                                                  cancelButtonTitle:@"I'll be back !"
                                                                  otherButtonTitles:nil];

        al.titleLabel.textColor               = ORANGE;
        al.titleLabel.font                    = [UIFont fontWithName:@"Futura" size:20];
        al.messageLabel.textColor             = [UIColor cloudsColor];
        al.messageLabel.font                  = [UIFont fontWithName:@"Futura" size:20];
        al.backgroundOverlay.backgroundColor  = PURPLE_DARK;
        al.alertContainer.backgroundColor     = [UIColor colorWithRed:83./255 green:38./255 blue:64./255 alpha:1];
        al.defaultButtonColor                 = PURPLE_DARK;
        al.defaultButtonShadowColor           = [UIColor clearColor];
        al.defaultButtonFont                  = [UIFont fontWithName:@"Futura" size:20];
        al.defaultButtonTitleColor            = ORANGE;
        al.alertContainer.layer.cornerRadius  = 5;
        al.alertContainer.layer.masksToBounds = YES;
        [al show];
    }
    
}

@end
