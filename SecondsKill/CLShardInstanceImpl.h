//
//  SHARD_INSTANCE_IMPL.h
//  Trackup-iOS
//
//  Created by lijingcheng on 13-8-12.
//  Copyright (c) 2013年 citylife. All rights reserved.
//

#define SHARD_INSTANCE_IMPL(ClassName) \
\
static ClassName *shardInstance = NULL; \
\
    + (id)shardInstance { \
        @synchronized(self) { \
            if (shardInstance == nil) { \
                shardInstance = [[self alloc] init]; \
            } \
        } \
        return shardInstance; \
    } \
/*\
    + (id)allocWithZone:(NSZone *)zone { \
        @synchronized(self) { \
            if (shardInstance == nil) { \
                shardInstance = [super allocWithZone:zone]; \
            return shardInstance; \
            } \
        } \
        return nil; \
    } \
\
    - (id)copyWithZone:(NSZone *)zone { \
        return self; \
    } \
\
    - (id)retain { \
        return self; \
    } \
\
    - (unsigned)retainCount { \
        return UINT_MAX; \
    } \
\
    - (oneway void)release { \
    } \
\
    - (id)autorelease { \
        return self; \
    }
*/
