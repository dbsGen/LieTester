//
//  LTTouchElement.h
//  LieTester
//
//  Created by zrz on 13-1-17.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTLightElement.h"

@interface LTTouchElement : LTLightElement

- (void)show;
- (void)miss;

@property (nonatomic, copy) void (^missBlock)(LTTouchElement *element);

@end
