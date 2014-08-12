//
//  CreateRecordTableViewController.m
//  QRist
//
//  Created by Adrian Rodriguez on 8/11/14.
//  Copyright (c) 2014 QRist. All rights reserved.
//

#import "CreateRecordTableViewController.h"

@interface CreateRecordTableViewController ()

// Patient ID Info
@property (retain, nonatomic) IBOutlet UITextField *patientID;
@property (retain, nonatomic) IBOutlet UITextField *firstName;
@property (retain, nonatomic) IBOutlet UITextField *middleName;
@property (retain, nonatomic) IBOutlet UITextField *lastName;

// Personal Info
@property (retain, nonatomic) IBOutlet UITextField *sex;
@property (retain, nonatomic) IBOutlet UITextField *height;
@property (retain, nonatomic) IBOutlet UITextField *weight;
@property (retain, nonatomic) IBOutlet UITextField *dateOfBirth;
@property (retain, nonatomic) IBOutlet UITextField *maritalStatus;

// Contact Info
@property (retain, nonatomic) IBOutlet UITextField *phone;
@property (retain, nonatomic) IBOutlet UITextField *email;
@property (retain, nonatomic) IBOutlet UITextField *city;
@property (retain, nonatomic) IBOutlet UITextField *address;
@property (retain, nonatomic) IBOutlet UITextField *zipCode;

// Emergency Contact
@property (retain, nonatomic) IBOutlet UITextField *emergencyContactName;
@property (retain, nonatomic) IBOutlet UITextField *emergencyContactRelation;
@property (retain, nonatomic) IBOutlet UITextField *emergencyContactEmail;

// Medical Restrictions
@property (retain, nonatomic) IBOutlet UITextView *allergies;
@property (retain, nonatomic) IBOutlet UITextView *medications;
@property (retain, nonatomic) IBOutlet UITextView *preconditions;

// Medical Evaluation
@property (retain, nonatomic) IBOutlet UITextView *diagnosis;
@property (retain, nonatomic) IBOutlet UITextView *prescription;
@property (retain, nonatomic) IBOutlet UITextView *notes;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@end

@implementation CreateRecordTableViewController {
    UIActivityIndicatorView *spinner;
}

- (IBAction)createRecord:(id)sender
{
    NSDictionary *inputtedRecord = [self enteredData];
    Patient *newPatient = [[Patient alloc] initWithRecord:inputtedRecord];
    [self startSpinner];
    
    [newPatient saveRecordCompletion:^{
        [self stopSpinner];
    } success:^{
        [self clearForm];
    } failure:^{
        [self showAlert];
    }];
    
}

- (NSMutableDictionary *)enteredData
{
    NSMutableDictionary *enteredData = [[NSMutableDictionary alloc] init];
    
    [enteredData setValue:self.patientID.text forKey:@"patientID"];
    [enteredData setValue:self.firstName.text forKey:@"firstName"];
    [enteredData setValue:self.middleName.text forKey:@"middleName"];
    [enteredData setValue:self.lastName.text forKey:@"lastName"];
    
    // Set Personal
    [enteredData setValue:self.sex.text forKey:@"sex"];
    [enteredData setValue:self.height.text forKey:@"height"];
    [enteredData setValue:self.weight.text forKey:@"weight"];
    [enteredData setValue:self.dateOfBirth.text forKey:@"dateOfBirth"];
    [enteredData setValue:self.maritalStatus.text forKey:@"maritalStatus"];
    
    // Set Contact
    [enteredData setValue:self.phone.text forKey:@"phone"];
    [enteredData setValue:self.email.text forKey:@"email"];
    [enteredData setValue:self.city.text forKey:@"city"];
    [enteredData setValue:self.address.text forKey:@"address"];
    [enteredData setValue:self.zipCode.text forKey:@"zipCode"];
    
    // Set EmContacts
    [enteredData setValue:self.emergencyContactName.text forKey:@"emergencyContactName"];
    [enteredData setValue:self.emergencyContactRelation.text forKey:@"emergencyContactRelation"];
    [enteredData setValue:self.emergencyContactEmail.text forKey:@"emergencyContactEmail"];
    
    // Set Restrictions
    [enteredData setValue:self.allergies.text forKey:@"allergies"];
    [enteredData setValue:self.medications.text forKey:@"medications"];
    [enteredData setValue:self.preconditions.text forKey:@"preconditions"];
    
    // Set Eval
    [enteredData setValue:self.diagnosis.text forKey:@"diagnosis"];
    [enteredData setValue:self.prescription.text forKey:@"prescription"];
    [enteredData setValue:self.notes.text forKey:@"notes"];
    
    return enteredData;
}

- (void)startSpinner
{
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *indicatorButton = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    [self navigationItem].rightBarButtonItem = indicatorButton;
    
    [spinner startAnimating];
}

- (void)stopSpinner
{
    [spinner stopAnimating];
    [self navigationItem].rightBarButtonItem = self.saveButton;
}
     
     
- (void)clearForm
{
    self.patientID.text = nil;
    self.firstName.text = nil;
    self.middleName.text = nil;
    self.lastName.text = nil;
    self.sex.text = nil;
    self.height.text = nil;
    self.weight.text = nil;
    self.maritalStatus.text = nil;
    self.dateOfBirth.text = nil;
    self.phone.text = nil;
    self.email.text = nil;
    self.city.text = nil;
    self.address.text = nil;
    self.zipCode.text = nil;
    self.emergencyContactName.text = nil;
    self.emergencyContactEmail.text = nil;
    self.emergencyContactRelation.text = nil;
    self.allergies.text = nil;
    self.preconditions.text = nil;
    self.medications.text = nil;
    self.diagnosis.text = nil;
    self.notes.text = nil;
    self.prescription.text = nil;
    
    [self.view endEditing:YES];
}

- (void)showAlert
{
    UIAlertView *saveError = [[UIAlertView alloc] initWithTitle:@"Save Error"
                                                        message:@"Please wait a moment and try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    [saveError show];
}

- (void)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_patientID release];
    [_firstName release];
    [_middleName release];
    [_lastName release];
    [_sex release];
    [_height release];
    [_weight release];
    [_dateOfBirth release];
    [_maritalStatus release];
    [_phone release];
    [_email release];
    [_city release];
    [_address release];
    [_zipCode release];
    [_emergencyContactName release];
    [_emergencyContactRelation release];
    [_emergencyContactEmail release];
    [_allergies release];
    [_medications release];
    [_preconditions release];
    [_diagnosis release];
    [_prescription release];
    [_notes release];
    [spinner release];
    [_saveButton release];
    [super dealloc];
}
@end
