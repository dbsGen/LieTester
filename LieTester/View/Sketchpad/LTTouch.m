//
//  LTTouch.m
//  LieTester
//
//  Created by zrz on 13-1-18.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTTouch.h"
#import "cocos2d.h"

#define kSize CGSizeMake(95, 95)

@implementation LTTouch {
    float   s_width, s_height;
    BOOL    _showing;
}

- (id)init
{
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"touch.png"];
    self = [super initWithTexture:texture];
    if (self) {
        s_width = kSize.width / texture.pixelsWide;
        s_height = kSize.height / texture.pixelsHigh;
        self.contentSize = kSize;
        self.anchorPoint = CGPointMake(1.5, 1.5);
        self.scaleX = s_width / 2;
        self.scaleY = s_height / 2;
    }
    return self;
}

- (id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
    self = [super initWithTexture:texture rect:rect rotated:rotated];
    if (self) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return self;
}

- (void)show
{
    if (_showing) {
        return;
    }
    _showing = YES;
    [self unschedule:@selector(update)];
    [self schedule:@selector(update) interval:0.1];
}

- (void)miss
{
    if (!_showing) {
        return;
    }
    _showing = NO;
    [self unschedule:@selector(update)];
    [self schedule:@selector(update)];
}

- (void)update
{
    if (_showing) {
        if ((s_width - self.scaleX) < 0.01 && (s_width - self.scaleX) > -0.01) {
            self.scaleX = s_width;
            self.scaleY = s_height;
            [self unschedule:@selector(update)];
            return;
        }
        self.scaleX = self.scaleX + (s_width - self.scaleX) * 0.1;
        self.scaleY = self.scaleY + (s_height - self.scaleY) * 0.1;
    }else {
        if (self.scaleX < 0.01 && self.scaleX > -0.01) {
            [self unschedule:@selector(update)];
            [self performSelector:@selector(callMissBlock)
                       withObject:nil
                       afterDelay:0];
            return;
        }
        self.scaleX = self.scaleX + (0 - self.scaleX) * 0.1;
        self.scaleY = self.scaleY + (0 - self.scaleY) * 0.1;
    }
}

- (void)callMissBlock
{
    if (self.missBlock) {
        self.missBlock(self);
    }
}

@end
