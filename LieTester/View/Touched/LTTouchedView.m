//
//  LTTouchedView.m
//  LieTester
//
//  Created by zrz on 13-1-17.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTTouchedView.h"
#import "LTTouchElement.h"

@implementation LTTouchedView {
    CGPoint     _oldPoint;
    LTTouchElement      *_lastElement;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setTouchPoint:(CGPoint)touchPoint
{
    if (!CGPointEqualToPoint(touchPoint, _oldPoint)) {
        //旧的消失
        [_lastElement miss];
        
        //新的出现
        _lastElement = [[LTTouchElement alloc] init];
        _lastElement.center = touchPoint;
        [_lastElement show];
        
        __unsafe_unretained LTTouchedView *this = self;
        _lastElement.missBlock = ^(LTTouchElement *sender) {
            [this.elements removeObject:sender];
        };
        [self.elements addObject:_lastElement];
    }
}

- (void)stopTouch
{
    for (LTElement *e in self.elements) {
        if ([e isKindOfClass:[LTTouchElement class]]) {
            //全部touch 消失
            [e performSelector:@selector(miss)
                    withObject:nil];
        }
    }
}

- (void)dealloc
{
    for (LTElement *e in self.elements) {
        if ([e isKindOfClass:[LTTouchElement class]]) {
            //清除 回调
            [e performSelector:@selector(setMissBlock:)
                    withObject:nil];
        }
    }
}

@end
