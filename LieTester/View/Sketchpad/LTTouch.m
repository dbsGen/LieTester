//
//  LTTouch.m
//  LieTester
//
//  Created by zrz on 13-1-18.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTTouch.h"
#import "cocos2d.h"

#define kSize CGSizeMake(190, 190)

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
        self.anchorPoint = CGPointMake(0.8, 0.8);
        self.scaleX = s_width * 0.8;
        self.scaleY = s_height * 0.8;
        self.opacity = 0;
    }
    return self;
}

- (id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
    self = [super initWithTexture:texture rect:rect rotated:rotated];
    if (self) {
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
        self.scaleX = self.scaleX + (s_width - self.scaleX) * 0.4;
        self.scaleY = self.scaleY + (s_height - self.scaleY) * 0.4;
        self.opacity = self.opacity + (255.0f - self.opacity) * 0.4;
    }else {
        if (self.scaleX < 0.01 && self.scaleX > -0.01) {
            [self unschedule:@selector(update)];
            [self performSelector:@selector(callMissBlock)
                       withObject:nil
                       afterDelay:0];
            return;
        }
        self.scaleX = self.scaleX + (0 - self.scaleX) * 0.01;
        self.scaleY = self.scaleY + (0 - self.scaleY) * 0.01;
        self.opacity = self.opacity + (0.0f - self.opacity) * 0.01;
        
    }
}

- (void)callMissBlock
{
    if (self.missBlock) {
        self.missBlock(self);
    }
}

@end
