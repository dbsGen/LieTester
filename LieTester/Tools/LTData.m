//
//  LTData.m
//  LieTester
//
//  Created by zrz on 13-1-16.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTData.h"

@implementation LTData

- (id)initWithData:(NSData *)data
{
    if (self = [super init]) {
        size_t length = data.length;
        char *buffer = malloc(length);
        [data getBytes:buffer];
        self.type = [self typeWithBuffer:buffer];
        self.message = [[NSString alloc] initWithBytes:buffer + 4
                                                length:length - 4
                                              encoding:NSUTF8StringEncoding];
        free(buffer);
    }
    return self;
}

- (NSInteger)typeWithBuffer:(char *)buffer
{
    NSInteger c = ((NSInteger*)buffer)[0];
    return c;
}

- (NSData *)data
{
    NSData *d1 = [self.message dataUsingEncoding:NSUTF8StringEncoding];
    char *buffer = malloc(d1.length + 4);
    ((NSInteger*)buffer)[0] = self.type;
    memcpy(buffer + 4, d1.bytes, d1.length);
    NSData *result = [NSData dataWithBytes:buffer
                                    length:d1.length + 4];
    free(buffer);
    return result;
}

+ (LTData *)dataWithType:(NSInteger)type
{
    LTData *data = [[LTData alloc] init];
    data.type = type;
    return data;
}

@end
