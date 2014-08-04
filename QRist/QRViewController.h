//
//  QRViewController.h
//  QRist
//
//  Created by Adrian Rodriguez on 8/3/14.
//  Copyright (c) 2014 QRist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QRViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewPreview;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblPrompt;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;

- (IBAction)startStopReading:(id)sender;

@end
