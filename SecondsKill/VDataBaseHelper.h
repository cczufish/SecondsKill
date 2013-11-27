//
//  VDataBaseHelper.h
//  SecondsKill
//
//  Created by lijingcheng on 13-11-26.
//  Copyright (c) 2013年 edouglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDataBaseHelper : NSObject

+ (VDataBaseHelper *)shardInstance;

//复制数据库到沙盒
- (void)copyDBToSandbox;

//批量更新表数据（删除后再添加）
- (void)batchDeleteAndInsert:(NSString *)tableName datas:(NSArray *)datas;

@end
