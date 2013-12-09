/* 
  readme.strings
  SecondsKill

  Created by lijingcheng on 13-11-6.
  Copyright (c) 2013年 edouglas. All rights reserved.
*/

修改过以下第三方框架，如果该框架不小心更新了代码，则需要按下面内容重新修改

1､YLProgressBar
    (1)、修改- (void)drawRect:(CGRect)rect方法，这样bar上的文字才能够显示在bar的底色区域：
        将“drawTrack“和“drawText“放到“drawProgressBar“之后去做
    (2)､修改- (void)drawProgressBar:(CGContextRef)context withRect:(CGRect)rect方法，取消颜色渐近效果：
        for (int i = 0; i < colorCount; i++)
        {
            //locations[i] = delta * i + semi_delta;
            locations[i] = 0;
        }
        
2､AES256和Base64类针对SecondsKill做过修改
3、REMenu.m文件中“- (void)showFromRect:(CGRect)rect inView:(UIView *)view“方法修改判断ios7的方式为IS_RUNNING_IOS7
4、SSToolkit
    (1)、NSData+SSToolkitAdditions.m文件
        static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        改成static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
5、SVProgressHUD.m
    （1)、- (NSTimeInterval)displayDurationForString:(NSString*)string方法
        return MIN((float)string.length*0.06 + 0.3, 5.0); - > return MIN((float)string.length*0.06 + 1, 5.0);