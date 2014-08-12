//
//  Patient.m
//  QRist
//
//  Created by Adrian Rodriguez on 8/9/14.
//  Copyright (c) 2014 QRist. All rights reserved.
//

#import "Patient.h"

#define API_KEY @"1ad96fd4-aa08-48a7-96e0-9a7624d15a39"
#define VAULT_ID @"00f73bf2-c2bf-4c4b-a02c-8ed5f2f6aeb4"
#define SCHEMA_ID @"bfa1efc3-883a-49c7-886d-25e7163b150f"

@interface Patient()

- (NSString *)encodedPatientRecord;
@property (nonatomic, strong) NSString *documentID;

@end

@implementation Patient

- (instancetype)initWithRecord:(NSDictionary *)patientRecord
{
    self = [super init];
    
    if (self) {
        if (patientRecord) self.medicalRecord = patientRecord;
    }
    return self;
}

- (void)saveRecordCompletion:(completion)completion success:(success)success failure:(failure)failure;
{
    // Format URL
    NSString *path = [NSString stringWithFormat:@"https://api.truevault.com/v1/vaults/%@/documents", VAULT_ID];
    NSURL *url = [NSURL URLWithString:path];
    
    // Format Authentication
    NSString *formatedAuth = [self authorizationPhrase];
    
    // Create and Format Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10];
    
    
    NSString *body = [NSString stringWithFormat:@"document=%@&schema_id=%@", [self encodedPatientRecord], SCHEMA_ID];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:formatedAuth forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSData dataWithBytes:[body UTF8String] length:strlen([body UTF8String])]];
    
    // Send Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // Format Result
        
        if (!connectionError) {
            NSError *error;
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", dataString);
            NSDictionary *respone = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (![respone valueForKey:@"error"]) {
                self.documentID = [respone valueForKey:@"document_id"];
                success();
            } else failure();
        } else failure();
        completion();
    }];
}

- (void)updateRecordonCompletion:(completion)completion success:(success)success failure:(failure)failure;
{
    
}

- (NSString *)authorizationPhrase
{
    NSString *authStr = [NSString stringWithFormat:@"%@:", API_KEY];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedAuth = [authData base64EncodedStringWithOptions:0];
    return [NSString stringWithFormat:@"Basic %@", encodedAuth];
}

- (NSString *)encodedPatientRecord
{
    NSError *error;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:self.medicalRecord options:0 error:&error];
    return [JSONData base64EncodedStringWithOptions:0];
}

+ (void)patientFromID:(NSString *)recordID completion:(void(^)(NSDictionary *patientRecord))completion;
{
    // Format URL
    NSString *path = [NSString stringWithFormat:@"https://api.truevault.com/v1/vaults/%@/documents/%@", VAULT_ID, recordID];
    NSURL *url = [NSURL URLWithString:path];
    
    // Format Authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:", API_KEY];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedAuth = [authData base64EncodedStringWithOptions:0];
    NSString *formatedAuth = [NSString stringWithFormat:@"Basic %@", encodedAuth];
    
    // Create and Format Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10];
    
    [request setValue:formatedAuth forHTTPHeaderField:@"Authorization"];
    
    // Send Request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // Format Result
        
        NSError *error = nil;
        if (!connectionError) {
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", dataString);
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:dataString options:0];
           
            NSDictionary *patientRecord = nil;
            
            if (decodedData) {
                patientRecord = [NSJSONSerialization JSONObjectWithData:decodedData options:0 error:&error];
                completion(patientRecord);
            } else completion(nil);
        }
    }];
}





@end
