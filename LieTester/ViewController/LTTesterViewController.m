//
//  LTTesterViewController.m
//  LieTester
//
//  Created by zrz on 13-1-16.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTTesterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LTSketchpad.h"

@interface LTTesterViewController ()
<CCDirectorDelegate>

@end

@implementation LTTesterViewController {
}

- (id)init
{
    self = [super init];
    if (self) {
        self.displayStats = YES;
        self.animationInterval = 1.0f/60.0f;
        self.delegate = self;
        self.wantsFullScreenLayout = YES;
        
    }
    return self;
}

- (void)loadView
{
    self.view = [CCGLView viewWithFrame:[[UIScreen mainScreen] bounds]
                            pixelFormat:kEAGLColorFormatRGB565
                            depthFormat:0 /* GL_DEPTH_COMPONENT24_OES */
                     preserveBackbuffer:NO
                             sharegroup:nil
                          multiSampling:NO
                        numberOfSamples:0];
    
    LTSketchpad *sketchpad = [LTSketchpad node];
    __unsafe_unretained LTTesterViewController *this = self;
    sketchpad.backGestureBlock = ^(id sender) {
        [this.navigationController popViewControllerAnimated:YES];
    };
    [self runWithScene:(id)sketchpad];
    
}

- (UIView *)view
{
    UIView *view = [super view];
    if (!view) {
        [self loadView];
    }
    return view_;
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//    _touchView = [[LTTouchedView alloc] initWithFrame:self.view.bounds];
//    _touchView.backgroundColor = [UIColor greenColor];
//    [_touchView startActionWithTimeInterval:0.02];
//    
//    [self.view addSubview:_touchView];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"%@", @"ad");
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [_touchView stopTouch];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [_touchView stopTouch];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self.view];
//    _touchView.touchPoint = p;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

@end
