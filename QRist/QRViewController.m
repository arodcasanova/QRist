//
//  QRViewController.m
//  QRist
//
//  Created by Adrian Rodriguez on 8/3/14.
//  Copyright (c) 2014 QRist. All rights reserved.
//

#import "QRViewController.h"
#import <Parse/Parse.h>

@interface QRViewController ()

@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

- (BOOL)startReading;
- (void)stopReading;
- (void)loadBeepSound;

@end

@implementation QRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _isReading = NO;
    _captureSession = nil;
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
            
            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start" waitUntilDone:NO];
            _isReading = NO;
            
            if (_audioPlayer) {
                [_audioPlayer play];
            }
        }
    }
}

- (void) loadBeepSound
{
//    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep-07" ofType:@"mp3"];
//    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
//    NSError *error;
//    
//    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
//    if (error) {
//        NSLog(@"Could not play beep file.");
//        NSLog(@"%@", [error localizedDescription]);
//    }
//    else {
//        [_audioPlayer prepareToPlay];
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
