//
//  LTSketchpad.h
//  LieTester
//
//  Created by zrz on 13-1-17.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "cocos2d.h"

@interface LTSketchpad : CCLayer

@property (nonatomic, copy) void (^backGestureBlock)(LTSketchpad *sender);

@end
