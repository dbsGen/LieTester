//
//  LTTesterViewController.m
//  LieTester
//
//  Created by zrz on 13-1-16.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTTesterViewController.h"
#import "LTTouchedView.h"
#import <QuartzCore/QuartzCore.h>

@interface LTTesterViewController ()

@end

@implementation LTTesterViewController {
    NSMutableArray  *_lights;
    LTTouchedView   *_touchView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _lights = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _touchView = [[LTTouchedView alloc] initWithFrame:self.view.bounds];
    _touchView.backgroundColor = [UIColor greenColor];
    [_touchView startActionWithTimeInterval:0.02];
    
    [self.view addSubview:_touchView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    
    _touchView.touchPoint = p;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchView stopTouch];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_touchView stopTouch];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self.view];
    _touchView.touchPoint = p;
}

@end
