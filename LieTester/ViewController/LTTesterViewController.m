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
#import "LTData.h"

@interface LTTesterViewController ()
<CCDirectorDelegate, LTLinkerDelegate>

@end

@implementation LTTesterViewController {
    LTSketchpad     *_sketchpad;
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

- (LTSketchpad *)sketchpad
{
    if (!_sketchpad) {
        _sketchpad = [LTSketchpad node];
        __unsafe_unretained LTTesterViewController *this = self;
        _sketchpad.backGestureBlock = ^(id sender) {
            [this.navigationController popViewControllerAnimated:YES];
        };
        _sketchpad.touchBeginBlock = ^(id sender) {
            this.linker.touching = YES;
        };
        _sketchpad.touchEndBlock = ^(id sender) {
            this.linker.touching = NO;
        };
    }
    return _sketchpad;
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
    
    [self runWithScene:(id)[self sketchpad]];
    
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

#pragma mark - linker delegate

- (void)backgroundResume
{
    CCTintTo *action = [CCTintTo actionWithDuration:0.4 red:50 green:255 blue:50];
    [_sketchpad.backgroundLayer runAction:action];
}

- (void)startTimer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(backgroundResume)
               withObject:nil
               afterDelay:10];
}

- (void)stopTimer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)linker:(LTLinker *)linker receiveMessage:(NSData *)message from:(NSString *)name
{
    LTData *data = [[LTData alloc] initWithData:message];
    switch (data.type) {
        case LTDataTypeTension:
        {
            CCTintTo *action = [CCTintTo actionWithDuration:0.4 red:0xf0 green:0xf0 blue:0x78];
            [_sketchpad.backgroundLayer runAction:action];
            //开始计时
            [self startTimer];
        }
            break;
        case LTDataTypeLie:
        {
            CCTintTo *action = [CCTintTo actionWithDuration:0.4 red:0xff green:0x00 blue:0x00];
            [_sketchpad.backgroundLayer runAction:action];
            //开始计时
            [self startTimer];
        }
            break;
        case LTDataTypeResume:
        {
            [self stopTimer];
            [self backgroundResume];
        }
            break;
            
        default:
            break;
    }

}

@end
