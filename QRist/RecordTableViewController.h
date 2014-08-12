//
//  RecordTableViewController.h
//  QRist
//
//  Created by Adrian Rodriguez on 8/8/14.
//  Copyright (c) 2014 QRist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface RecordTableViewController : UITableViewController

@property (nonatomic, strong) Patient *currentPatient;

@end
