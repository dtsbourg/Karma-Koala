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
    [self.signUpView setBackgroundColor:[UIColor colorWithRed:83./255 green:38./255 blue:64./255 alpha:1]];
    [self.signUpView setLogo:nil];
    [self.signUpView setTintColor:[UIColor whiteColor]];
    
    [self.signUpView.usernameField setBackgroundColor:[UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1]];
    [self.signUpView.passwordField setBackgroundColor:[UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1]];
    [self.signUpView.emailField setBackgroundColor:[UIColor colorWithRed:53./255 green:25./255 blue:55./255 alpha:1]];
    
    [self.signUpView.usernameField setTextColor:[UIColor whiteColor]];
    [self.signUpView.passwordField setTextColor:[UIColor whiteColor]];
    [self.signUpView.emailField setTextColor:[UIColor whiteColor]];
    
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karma.png"]]];
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [user setObject:@0 forKey:@"karma"];
    [user setObject:self.signUpView.usernameField.text forKey:@"user"];
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
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
    [self.signUpView.dismissButton setFrame:CGRectMake(self.signUpView.dismissButton.frame.origin.x, 30, self.signUpView.dismissButton.frame.size.width, self.signUpView.dismissButton.frame.size.height)];
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    
    UIColor *color = [UIColor colorWithWhite:1 alpha:0.7];
    UIFont *font = [UIFont fontWithName:@"Futura" size:20];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, font, NSFontAttributeName, nil];
    
    self.signUpView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:attrsDictionary];
    self.signUpView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:attrsDictionary];
    self.signUpView.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:attrsDictionary];

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
