//
//  LTTouchedView.h
//  LieTester
//
//  Created by zrz on 13-1-17.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTSketchpadView.h"

@interface LTTouchedView : LTSketchpadView

@property (nonatomic, assign)   CGPoint touchPoint;
- (void)stopTouch;

@end
