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


@end

@implementation LoginViewController

- (IBAction)touchedLoginButton:(UIButton *)sender {
    PFUser *user = [PFUser user];
    user.username = self.usernameInput.text;
    user.password = @"my pass";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Blammo!");
            [self performSegueWithIdentifier:@"login" sender:self];
        } else {
            NSLog(@"Error");
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [super dealloc];
}
@end
