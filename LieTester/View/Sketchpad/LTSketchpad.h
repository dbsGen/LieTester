//
//  LTSketchpad.h
//  LieTester
//
//  Created by zrz on 13-1-17.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "cocos2d.h"
#import "LTBackground.h"

@interface LTSketchpad : CCLayer

@property (nonatomic, readonly) LTBackground    *backgroundLayer;

@property (nonatomic, copy) void (^backGestureBlock)(LTSketchpad *sender);
@property (nonatomic, copy) void (^touchBeginBlock)(LTSketchpad *sender);
@property (nonatomic, copy) void (^touchEndBlock)(LTSketchpad *sender);

@end
