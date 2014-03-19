//
//  SignUpViewController.m
//  RoomieParse
//
//  Created by Dylan Bourgeois on 19/02/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
    
    
    [self.signUpView setBackgroundColor:PURPLE_LIGHT];
    [self.signUpView setTintColor:WHITE];
    
    [self.signUpView.usernameField setBackgroundColor:PURPLE_DARK];
    [self.signUpView.passwordField setBackgroundColor:PURPLE_DARK];
    [self.signUpView.emailField setBackgroundColor:PURPLE_DARK];
    
    [self.signUpView.usernameField setTextColor:WHITE];
    [self.signUpView.passwordField setTextColor:WHITE];
    [self.signUpView.emailField setTextColor:WHITE];
    
    self.signUpView.usernameField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karma.png"]]];
    
    if ([UIScreen mainScreen].bounds.size.height < 568)
        [self.signUpView.logo setFrame:CGRectMake(self.signUpView.logo.frame.origin.x,
                                                  self.signUpView.logo.frame.origin.y,
                                                  self.signUpView.logo.frame.size.width -80,
                                                  self.signUpView.logo.frame.size.height-80)];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    [self setFontFamily:@"Futura" forView:view andSubViews:YES];
}

-(void)viewDidLayoutSubviews {
    [self.signUpView.signUpButton setImage:[UIImage imageNamed:@"purple_signup.png"] forState:UIControlStateNormal];
    
    [self.signUpView.dismissButton setFrame:CGRectMake(self.signUpView.dismissButton.frame.origin.x +10,
                                                       30,
                                                       self.signUpView.dismissButton.frame.size.width,
                                                       self.signUpView.dismissButton.frame.size.height)];
    
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    

    UIColor *color                = [UIColor colorWithWhite:1 alpha:0.7];
    UIFont *font                  = [UIFont fontWithName:@"Futura" size:20];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName, nil];
    
    self.signUpView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:attrsDictionary];
    self.signUpView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:attrsDictionary];
    self.signUpView.emailField.attributedPlaceholder    = [[NSAttributedString alloc] initWithString:@"Email" attributes:attrsDictionary];

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
        al.alertContainer.backgroundColor     = PURPLE_LIGHT;
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
