//
//  APIGeeHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-15.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "APIGeeHelper.h"

@interface APIGeeHelper ()

@property (strong, nonatomic) ApigeeClient *apigeeClient; //object for initializing the App Services SDK
@property (strong, nonatomic) ApigeeMonitoringClient *monitoringClient; //client object for Apigee App Monitoring methods
@property (strong, nonatomic) ApigeeDataClient *dataClient;	//client object for App Services data methods

@end

@implementation APIGeeHelper

- (id)xx
{
    //Instantiate ApigeeClient to initialize the SDK
    _apigeeClient = [[ApigeeClient alloc] initWithOrganizationId:APIGEE_ORGNAME applicationId:APIGEE_APPNAME];
    
    //Retrieve instances of ApigeeClient.monitoringClient and ApigeeClient.dataClient
    self.monitoringClient = [_apigeeClient monitoringClient]; //used to call App Monitoring methods
    self.dataClient = [_apigeeClient dataClient]; //used to call data methods
    [self.dataClient setLogging:true];


    return nil;
}


-(NSString*)postBook {
    
    NSMutableDictionary *entity = [[NSMutableDictionary alloc] init ];
    
    [entity setObject:@"book" forKey:@"type"];
    [entity setObject:@"the old man and the sea" forKey:@"title"];
    
    ApigeeClientResponse *response = [self.dataClient createEntity:entity];
    
    @try {
        NSLog(@"%@",response.response);
        NSArray * books = [response.response objectForKey:@"entities"];;
        return [books objectAtIndex:0];
    }
    @catch (NSException * e) {
        return @"false";
    }
}


@end
