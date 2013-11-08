//
//  VHeader.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-31.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#ifndef SecondsKill_VHeader_h
#define SecondsKill_VHeader_h

//#define _AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_

//#define BASE_URL @"https://192.168.10.16:8443/Trackup/"
//#define APP_KEY @"dGVzdDp0ZXN0"
//#define APP_NAME @"秒杀惠"
//#define DB_NAME @"trackup.sqlite3"
//#define AES256_PASSWORD_KEY @"citylife20130609"
//
//#define UMENG_APPKEY @"5253608956240bb5182daaa8"
//
//#define DEFAULT_PAGE 1
//#define DEFAULT_PAGESIZE 5
#define FONT_NAME @"Helvetica-Bold"
//#define REQUEST_TIMEOUT_INTERVAL 120.0f


    #define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
    #define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

    #define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
    #define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
    #define STATUSBAR_HEIGHT 20
    #define NAVIGATIONBAR_HEIGHT 44
    #define FRAME_HEIGHT SCREEN_HEIGHT - STATUSBAR_HEIGHT
    #define CONTENT_VIEW_HEIGHT SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT

    #define isRetina ([[UIScreen mainScreen] scale] == 2)
    #define isPadX (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    #define isPhone5 (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568) < DBL_EPSILON)
    #define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

    #ifdef DEBUG
        #define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    #else
        #define NSLog(...);
    #endif

#endif
