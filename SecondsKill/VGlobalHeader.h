//
//  VGlobalHeader.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#ifndef SecondsKill_VGlobalHeader_h
#define SecondsKill_VGlobalHeader_h

    #define kBaseURL @"https://115.29.46.104/"
    #define DEFAULT_URI @"msitems"
    #define NETWORK_ERROR @"网络错误!"

    #define UMENG_APPKEY @"522e80dc56240b3cbc02d78b"

    #define AES256_KEY @"citylife20130609trackup"

    #define DEVICE_KEY @"deviceIdKey"
    #define SESSION_KEY @"sessionKey"
    #define USER_ID_KEY @"userIdKey"

    #define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
    #define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

    #define DEFAULT_PAGE_SIZE 20
    #define NAV_BACKGROUND_COLOR RGBCOLOR(199, 55, 33)

    #define FONT_NAME @"HelveticaNeue"
    #define DEFAULT_FONT [UIFont fontWithName:FONT_NAME size:16]

    #define IS_IPHONE5 (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568) < DBL_EPSILON)

    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        #define IS_RUNNING_IOS7 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7)
    #else
        #define IS_RUNNING_IOS7 NO
    #endif

    #ifdef DEBUG
        #define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    #else
        #define NSLog(...);
    #endif

    #define SHARD_INSTANCE_IMPL(ClassName) \
        \
        + (id)shardInstance \
        { \
            static dispatch_once_t pred = 0; \
            static ClassName *sharedObject = nil; \
        \
            dispatch_once(&pred, ^{ \
                sharedObject = [[self alloc] init]; \
            }); \
            return sharedObject; \
        } \

#endif
