//
//  LTSketchpad.m
//  LieTester
//
//  Created by zrz on 13-1-17.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTSketchpad.h"
#import "cocos2d.h"
#import "LTBackground.h"
#import "LTTouch.h"

#define kSize   CGSizeMake(190, 190)

@implementation LTSketchpad {
    LTBackground    *_backgroundLayer;
    CGPoint _oldPoint;
    LTTouch *_lastTouch;
    NSMutableArray  *_allTouches;
}

- (void)dealloc
{
    for (LTTouch *touch in _allTouches) {
        touch.missBlock = nil;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _backgroundLayer = [LTBackground layerWithColor:ccc4(50, 255, 50, 255)
                                                  width:self.contentSize.width
                                                 height:self.contentSize.height];
        _backgroundLayer.position = CGPointMake(0, 0);
        [self addChild:_backgroundLayer];
        
        self.isTouchEnabled = YES;
        
        _allTouches = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setPoint:(CGPoint)p
{
//    if (CGPointEqualToPoint(p, _oldPoint)) {
//        return;
//    }
    //旧的消失
    GLubyte opacity = _lastTouch.opacity;
    float sx = _lastTouch.scaleX;
    float sy = _lastTouch.scaleY;
    [_lastTouch miss];
    
    //新的出现
    _oldPoint = p;
    _lastTouch = [LTTouch node];
    _lastTouch.position = p;
    _lastTouch.opacity = opacity;
    _lastTouch.scaleX = sx;
    _lastTouch.scaleY = sy;
    __unsafe_unretained LTSketchpad *this = self;
    _lastTouch.missBlock = ^(LTTouch *sender) {
        [this removeChild:sender cleanup:YES];
        [this->_allTouches removeObject:sender];
    };
    [_allTouches addObject:_lastTouch];
    [self addChild:_lastTouch];
    [_lastTouch show];
}

- (void)touchEnd
{
    for (LTTouch *touch in _allTouches) {
        [touch miss];
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint lp = [touch locationInView:[touch view]];
    CGPoint p = [[CCDirector sharedDirector] convertToGL:lp];
    [self setPoint:p];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint lp = [touch locationInView:[touch view]];
    CGPoint p = [[CCDirector sharedDirector] convertToGL:lp];
    [self setPoint:p];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchEnd];
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchEnd];
}

@end
