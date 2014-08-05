//
//  LoginViewController.m
//  QRist
//
//  Created by Adrian Rodriguez on 8/4/14.
//  Copyright (c) 2014 QRist. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()

@property (retain, nonatomic) IBOutlet UITextField *usernameInput;
@property (retain, nonatomic) IBOutlet UITextField *passwordInput;

@end

@implementation LoginViewController

- (IBAction)touchedLoginButton:(UIButton *)sender
{
    if ([self loginInfoInputted]) {
        [PFUser logInWithUsernameInBackground:self.usernameInput.text
                                     password:self.passwordInput.text
            block:^(PFUser *user, NSError *error) {
                if (error) {
                    UIAlertView *invalidLoginAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Login"
                                                                                message:@"Please try again."
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil, nil];
                
                [invalidLoginAlert show];
            } else [self performSegueWithIdentifier:@"login" sender:self];
        }];
    }
}

- (BOOL)loginInfoInputted
{
    if (!self.usernameInput.text || self.usernameInput.text.length == 0) {
        UIAlertView *missingUsername = [[UIAlertView alloc] initWithTitle:@"Missing Username"
                                                                  message:@"Please enter a username."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil, nil];
        [missingUsername show];
        return NO;
    }
    
    if (!self.passwordInput.text || self.passwordInput.text.length == 0) {
        UIAlertView *missingPassword = [[UIAlertView alloc] initWithTitle:@"Missing Password"
                                                                  message:@"Please enter a password."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil, nil];
        [missingPassword show];
        return NO;
    }
    
    return YES;
}

- (void)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_usernameInput release];
    [_passwordInput release];
    [super dealloc];
}
@end
