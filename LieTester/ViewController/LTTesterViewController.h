//
//  LTTesterViewController.h
//  LieTester
//
//  这个页面写一个Z可以返回上一页
//
//  Created by zrz on 13-1-16.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "LTLinker.h"

@interface LTTesterViewController : CCDirectorDisplayLink

@property (nonatomic, strong) LTLinker *linker;

@end
