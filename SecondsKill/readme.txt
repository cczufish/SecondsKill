/* 
  readme.strings
  SecondsKill

  Created by lijingcheng on 13-11-6.
  Copyright (c) 2013年 edouglas. All rights reserved.
*/

修改过以下第三方框架，如果该框架不小心更新了代码，则需要按下面内容重新修改

1､YLProgressBar
    (1)、修改- (void)drawRect:(CGRect)rect方法：
        将“drawTrack“和“drawText“放到“drawProgressBar“之后去做
    (2)､修改- (void)drawProgressBar:(CGContextRef)context withRect:(CGRect)rect方法：
        for (int i = 0; i < colorCount; i++)
        {
            //locations[i] = delta * i + semi_delta;
            locations[i] = 0;
        }
