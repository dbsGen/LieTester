//
//  LTTouchedView.m
//  LieTester
//
//  Created by zrz on 13-1-17.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTSketchpadView.h"
#import "LTElement.h"

@implementation LTSketchpadView {
    NSTimeInterval  _timeInterval;
    BOOL    _action;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *)elements
{
    if (!_elements) {
        _elements = [[NSMutableArray alloc] init];
    }
    return _elements;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (LTElement *element in self.elements) {
        element.backgroundColor = self.backgroundColor;
        [element drawOnContext:context];
    }
}

- (void)stepCheck
{
    if (_action) {
        for (LTElement *e in self.elements) {
            [e step];
        }
        [self setNeedsDisplay];
        [self performSelector:@selector(stepCheck)
                   withObject:nil
                   afterDelay:_timeInterval];
    }
}

- (void)startActionWithTimeInterval:(NSTimeInterval)timeInterval
{
    if (!_action) {
        _timeInterval = timeInterval;
        [self performSelector:@selector(stepCheck)
                   withObject:nil
                   afterDelay:timeInterval];
        _action = YES;
    }
}

- (void)stopAction
{
    if (_action) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        _action = NO;
    }
}

@end
