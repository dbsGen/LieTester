//
//  LTLightElement.m
//  LieTester
//
//  Created by zrz on 13-1-17.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTLightElement.h"

@implementation LTLightElement

- (void)drawOnContext:(CGContextRef)context
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (__bridge CFArrayRef)@[(id)[UIColor colorWithWhite:1 alpha:0.7].CGColor,
                                                        (id)self.backgroundColor.CGColor],
                                                        NULL);
    
    CGColorSpaceRelease(colorSpace);
    CGContextDrawRadialGradient(context,
                                gradient,
                                self.center,
                                self.radios / 2,
                                self.center,
                                self.radios,
                                kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(gradient);
}

@end
