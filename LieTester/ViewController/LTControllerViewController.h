//
//  LTControllerViewController.h
//  LieTester
//
//  Created by zrz on 13-1-16.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTLinker.h"

@interface LTControllerViewController : UIViewController

@property (nonatomic, strong) LTLinker *linker;

@property (nonatomic, strong) IBOutlet  UILabel *stateLabel;

- (IBAction)lieClicked:(id)sender;
- (IBAction)tensionClicked:(id)sender;
- (IBAction)resumeClicked:(id)sender;

- (IBAction)backClicked:(id)sender;

@end
