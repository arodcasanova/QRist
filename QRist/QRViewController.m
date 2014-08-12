//
//  QRViewController.m
//  QRist
//
//  Created by Adrian Rodriguez on 8/3/14.
//  Copyright (c) 2014 QRist. All rights reserved.
//

#import "QRViewController.h"
#import <Parse/Parse.h>
#import "Patient.h"
#import "RecordTableViewController.h"

@interface QRViewController ()

@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (BOOL)startReading;
- (void)stopReading;

@end

@implementation QRViewController {
    Patient *recievedPatient;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _isReading = NO;
    _captureSession = nil;
    [self.activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopReading:(id)sender
{
    if (!_isReading) {
        if ([self startReading]) {
            [_bbitemStart setTitle:@"Stop"];
            [_bbitemStart setTintColor:[UIColor redColor]];
            [_lblStatus setText:@"Scanning for QR Code"];
            [_lblStatus setTextColor: [UIColor whiteColor]];
            [_lblStatus setTextAlignment:NSTextAlignmentCenter];
        }
    }  else {
        [self stopReading];
        [_bbitemStart setTitle:@"Start"];
        [_lblStatus setText:@"Stopped Scanning"];
        [_bbitemStart setTintColor:[UIColor greenColor]];
    }
    
    _isReading = !_isReading;
}

- (BOOL)startReading
{
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading
{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopReading];
                [_bbitemStart setTitle:@"Start"];
                [_bbitemStart setTintColor:[UIColor greenColor]];
                _isReading = NO;
                
                [self fetchPatientWithID:[metadataObj stringValue] success:^(Patient *fetchedPatient) {
                    NSLog(@"Ready for transtion");
                    [_lblStatus setText:@"QR Reader is not scanning"];
                    recievedPatient = fetchedPatient;
                    [self performSegueWithIdentifier:@"Show Record" sender:self];
                } failure:^(NSError *error) {
                    NSLog(@"No record found");
                    [_lblStatus setTextColor: [UIColor redColor]];
                    [_lblStatus setText:@"No record found"];
                }];
                
            });
        
        }
    }
}

- (void)fetchPatientWithID:(NSString*)patientID success:(void (^)(Patient *))success failure:(void (^)(NSError *))failure
{
    [self.activityIndicator startAnimating];
    [_lblStatus setText:@"Searching for record..."];
    
    __block NSDictionary *patientRecord = nil;
    __block Patient *patient = nil;
    
    [Patient patientFromID:patientID completion:^(NSDictionary *fetchedRecord) {
        if (fetchedRecord) {
            patientRecord = fetchedRecord;
            patient = [[Patient alloc] initWithRecord:patientRecord];
            success(patient);
        } else {
            NSLog(@"No record");
            NSError *error = nil;
            failure(error);
        }
        [self.activityIndicator stopAnimating];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[RecordTableViewController class]]) {
        RecordTableViewController *dest = (RecordTableViewController *)segue.destinationViewController;
        
        if (!recievedPatient) NSLog(@"Pat still nil");
        
        dest.currentPatient = recievedPatient;
    }
}


- (void)dealloc {
    [_activityIndicator release];
    [super dealloc];
}
@end
