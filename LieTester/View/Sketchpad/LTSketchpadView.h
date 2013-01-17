//
//  LTTouchedView.h
//  LieTester
//
//  Created by zrz on 13-1-17.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTSketchpadView : UIView

- (void)startActionWithTimeInterval:(NSTimeInterval)timeInterval;
- (void)stopAction;

@property (nonatomic, strong)   NSMutableArray  *elements;

@end
