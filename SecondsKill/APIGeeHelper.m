//
//  APIGeeHelper.m
//  SecondsKill
//
//  Created by lijingcheng on 13-11-15.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import "APIGeeHelper.h"

#define APIGEE_ORGNAME @"athui"
#define APIGEE_APPNAME @"sandbox"
#define APIGEE_BASEURL @"https://www.athui.com"
#define APIGEE_TYPE @"msitems"

static ApigeeClient *apigeeClient;
static ApigeeDataClient *dataClient;

@implementation APIGeeHelper

SHARD_INSTANCE_IMPL(APIGeeHelper)

- (void)initialize
{
    apigeeClient = [[ApigeeClient alloc] initWithOrganizationId:APIGEE_ORGNAME applicationId:APIGEE_APPNAME baseURL:APIGEE_BASEURL];
    dataClient = [apigeeClient dataClient];
    
    #ifdef DEBUG
        [dataClient setLogging:true];
    #endif
}

+ (ApigeeClientResponse *)requestByQL:(NSString *)ql
{
    return [dataClient getEntities:APIGEE_TYPE queryString:ql];
}

//- (BOOL)postMessage:(NSString*)message {
//    
//    NSMutableDictionary *activityProperties = [[NSMutableDictionary alloc] init];
//    [activityProperties setObject:APIGEE_TYPE forKey:@"type"];
//    [activityProperties setObject:@"xxx" forKey:@"title"];
//    
//    ApigeeClientResponse *response = [self.dataClient createEntity:activityProperties];
//    
//    return [response completedSuccessfully];
//}

@end
