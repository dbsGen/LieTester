//
//  LTData.h
//  LieTester
//
//  Created by zrz on 13-1-16.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LTDataTypeUnkown,
    LTDataTypeAsk,          //连接之前的询问
    LTDataTypeReplyAsk,     //连接询问的回复
    LTDataTypeTouchBegin,   //测谎仪端开始按下
    LTDataTypeTouchEnd,     //测谎仪结束
    LTDataTypeLie,          //撒谎
    LTDataTypeTension,
    LTDataTypeResume,       //恢复
} LTDataType;

@interface LTData : NSObject

@property (nonatomic, assign)   NSInteger   type;
@property (nonatomic, strong)   NSString    *message;

- (id)initWithData:(NSData *)data;
+ (LTData *)dataWithType:(NSInteger)type;
- (NSData *)data;

@end
