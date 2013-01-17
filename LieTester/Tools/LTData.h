//
//  LTData.h
//  LieTester
//
//  Created by zrz on 13-1-16.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LTDataTypeAsk,
    LTDataTypeReplyAsk
} LTDataType;

@interface LTData : NSObject

@property (nonatomic, assign)   NSInteger   type;
@property (nonatomic, strong)   NSString    *message;

- (id)initWithData:(NSData *)data;
+ (LTData *)dataWithType:(NSInteger)type;
- (NSData *)data;

@end
