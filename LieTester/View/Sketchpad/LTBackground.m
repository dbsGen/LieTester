//
//  LTBackground.m
//  LieTester
//
//  Created by zrz on 13-1-18.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTBackground.h"

@implementation LTBackground

- (id)initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h
{
    self = [super initWithColor:color width:w height:h];
    if (self) {
        self.isTouchEnabled = YES;
    }
    return self;
}

@end
