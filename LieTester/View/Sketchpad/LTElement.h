//
//  LTElement.h
//  LieTester
//
//  Created by zrz on 13-1-17.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTElement : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
- (void)drawOnContext:(CGContextRef)context;

- (void)step;

@end
