//
//  LTTouch.h
//  LieTester
//
//  Created by zrz on 13-1-18.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "CCSprite.h"

@interface LTTouch : CCSprite

@property (nonatomic, copy) void (^missBlock)(LTTouch *sender);

- (void)show;
- (void)miss;

@end
