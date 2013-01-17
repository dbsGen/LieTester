//
//  LTTouchElement.m
//  LieTester
//
//  Created by zrz on 13-1-17.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTTouchElement.h"

@implementation LTTouchElement {
    BOOL    _show;
}

- (void)show
{
    if (!_show) {
        _show = YES;
    }
}

- (void)miss
{
    _show = NO;
}

- (void)step
{
    if (_show) {
        self.radios = self.radios >= 94.5 ? 95 : self.radios + (95 - self.radios) * 0.5;
    }else {
        if (self.radios <= 2) {
            self.radios = 0;
            [self performSelector:@selector(thisMiss)
                       withObject:nil
                       afterDelay:0];
        }else {
            self.radios -= 2;
        }
    }
}

- (void)thisMiss
{
    if (self.missBlock) {
        self.missBlock(self);
    }
}

@end
