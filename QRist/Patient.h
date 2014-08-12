//
//  Patient.h
//  QRist
//
//  Created by Adrian Rodriguez on 8/9/14.
//  Copyright (c) 2014 QRist. All rights reserved.
//

#import <Foundation/Foundation.h>


/* 
 * All properties are strings because they will simply
 * bet set as text labels and therefore will never be
 * numerically operated on.
 */

typedef void(^success)(void);
typedef void(^failure)(void);
typedef void(^completion)(void);

@interface Patient : NSObject

// designated initializer
- (instancetype)initWithRecord:(NSDictionary *)patientRecord;

- (void)saveRecordCompletion:(completion)completion success:(success)success failure:(failure)failure;
- (void)updateRecordonCompletion:(completion)completion success:(success)success failure:(failure)failure;

+ (void)patientFromID:(NSString *)recordID completion:(void(^)(NSDictionary *patientRecord))completion;

@property (nonatomic, strong) NSDictionary *medicalRecord;

@end
