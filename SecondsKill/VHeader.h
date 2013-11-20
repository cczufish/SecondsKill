//
//  VHeader.h
//  SecondsKill
//
//  Created by lijingcheng on 13-10-31.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#ifndef SecondsKill_VHeader_h
#define SecondsKill_VHeader_h

//#define BASE_URL @"https://192.168.10.16:8443/Trackup/"
//#define DB_NAME @"secondskill.db"
//
    #define UMENG_APPKEY @"522e80dc56240b3cbc02d78b"
#define TENCENT_APPID @"801430933"
#define WEIXIN_APPID @"wxwxcdef309f0d88c12b"


#warning 用发布证书编译打包程序
#warning 替换apigee debug sdk 为release版本

#define FONT_NAME @"Arial-BoldMT"

    

#define FONT_SIZE 16
#define DEFAULT_FONT [UIFont fontWithName:FONT_NAME size:FONT_SIZE]


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

#endif



