//
//  RecordTableViewController.m
//  QRist
//
//  Created by Adrian Rodriguez on 8/8/14.
//  Copyright (c) 2014 QRist. All rights reserved.
//

#import "RecordTableViewController.h"

@interface RecordTableViewController ()

// Patient ID
@property (retain, nonatomic) IBOutlet UILabel *patientID;
@property (retain, nonatomic) IBOutlet UILabel *firstName;
@property (retain, nonatomic) IBOutlet UILabel *middleName;
@property (retain, nonatomic) IBOutlet UILabel *lastName;

// Persoanl Info
@property (retain, nonatomic) IBOutlet UILabel *sex;
@property (retain, nonatomic) IBOutlet UILabel *height;
@property (retain, nonatomic) IBOutlet UILabel *weight;
@property (retain, nonatomic) IBOutlet UILabel *dateOfBirth;
@property (retain, nonatomic) IBOutlet UILabel *maritalStatus;

// Contact Info
@property (retain, nonatomic) IBOutlet UILabel *phone;
@property (retain, nonatomic) IBOutlet UILabel *email;
@property (retain, nonatomic) IBOutlet UILabel *city;
@property (retain, nonatomic) IBOutlet UILabel *address;
@property (retain, nonatomic) IBOutlet UILabel *zipCode;

// Emergency Contact
@property (retain, nonatomic) IBOutlet UILabel *emergencyContactName;
@property (retain, nonatomic) IBOutlet UILabel *emergencyContactRelation;
@property (retain, nonatomic) IBOutlet UILabel *emergencyContactEmail;

// Medical Restrictions
@property (retain, nonatomic) IBOutlet UITextView *allergies;
@property (retain, nonatomic) IBOutlet UITextView *medications;
@property (retain, nonatomic) IBOutlet UITextView *preConditions;

// Medical Evaluation
@property (retain, nonatomic) IBOutlet UITextView *diagnosis;
@property (retain, nonatomic) IBOutlet UITextView *prescriptions;
@property (retain, nonatomic) IBOutlet UITextView *notes;

@end

@implementation RecordTableViewController

- (void)initFields
{
    self.patientID.text = [self.currentPatient.medicalRecord valueForKey:@"patientID"];
    self.firstName.text = [self.currentPatient.medicalRecord valueForKey:@"firstName"];
    self.middleName.text = [self.currentPatient.medicalRecord valueForKey:@"middleName"];
    self.lastName.text = [self.currentPatient.medicalRecord valueForKey:@"lastName"];
    
    self.sex.text = [self.currentPatient.medicalRecord valueForKey:@"sex"];
    self.height.text = [self.currentPatient.medicalRecord valueForKey:@"height"];
    self.weight.text = [self.currentPatient.medicalRecord valueForKey:@"weight"];
    self.dateOfBirth.text = [self.currentPatient.medicalRecord valueForKey:@"dateOfBirth"];
    self.maritalStatus.text = [self.currentPatient.medicalRecord valueForKey:@"maritalStatus"];

    self.phone.text = [self.currentPatient.medicalRecord valueForKey:@"phoneNumber"];
    self.email.text = [self.currentPatient.medicalRecord valueForKey:@"email"];
    self.city.text = [self.currentPatient.medicalRecord valueForKey:@"city"];
    self.address.text = [self.currentPatient.medicalRecord valueForKey:@"address"];
    self.zipCode.text = [self.currentPatient.medicalRecord valueForKey:@"zipCode"];
    
    self.emergencyContactName.text = [self.currentPatient.medicalRecord valueForKey:@"emergencyContactName"];
    self.emergencyContactRelation.text = [self.currentPatient.medicalRecord valueForKey:@"emergencyContactRelation"];
    self.emergencyContactEmail.text = [self.currentPatient.medicalRecord valueForKey:@"emergencyContactEmail"];
    
    self.allergies.text = [self.currentPatient.medicalRecord valueForKey:@"allergies"];
    self.medications.text = [self.currentPatient.medicalRecord valueForKey:@"medications"];
    self.preConditions.text = [self.currentPatient.medicalRecord valueForKey:@"preconditions"];
    
    self.diagnosis.text = [self.currentPatient.medicalRecord valueForKey:@"diagnosis"];
    self.prescriptions.text = [self.currentPatient.medicalRecord valueForKey:@"prescription"];
    self.notes.text = [self.currentPatient.medicalRecord valueForKey:@"notes"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    [_phone release];
    [_maritalStatus release];
    [_email release];
    [_city release];
    [_address release];
    [_zipCode release];
    [_emergencyContactName release];
    [_emergencyContactRelation release];
    [_emergencyContactEmail release];
    [_allergies release];
    [_medications release];
    [_preConditions release];
    [_diagnosis release];
    [_prescriptions release];
    [_notes release];
    [super dealloc];
}

@end
