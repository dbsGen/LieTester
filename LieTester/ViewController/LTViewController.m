//
//  LTViewController.m
//  LieTester
//
//  Created by zrz on 13-1-16.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTViewController.h"
#import "LTLinker.h"
#import "LTControllerViewController.h"
#import "LTTesterViewController.h"
#import "cocos2d.h"

@interface LTViewController ()
<LTLinkerDelegate>

@end

@interface LTViewController () {
    LTLinker    *_linker;
    LTCharacter _type;
}

@end

@implementation LTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (LTLinker *)linker
{
    if (!_linker) {
        _linker = [[LTLinker alloc] init];
        _linker.delegate = self;
    }
    return _linker;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - actions

- (IBAction)controllerClicked:(id)sender
{
    _type = LTController;
    [[self linker] startAsController];
}

- (IBAction)testerClicked:(id)sender
{
//    LTTesterViewController *ctrl = (id)[LTTesterViewController sharedDirector];
//    [self.navigationController pushViewController:ctrl
//                                         animated:YES];
    _type = LTTester;
    [[self linker] startAsTester];
}

#pragma mark - linker delegate


- (void)linker:(LTLinker *)linker connectSuccessWith:(NSString *)name
{
    //连接成功
    switch (_type) {
        case LTController:
        {
            LTControllerViewController *ctrl = [[LTControllerViewController alloc] init];
            ctrl.linker = _linker;
            _linker.delegate = (id)ctrl;
            _linker = nil;
            [self.navigationController pushViewController:ctrl
                                                 animated:YES];
        }
            break;
            
        case LTTester:
        {
            LTTesterViewController *ctrl = (id)[LTTesterViewController sharedDirector];
            ctrl.linker = _linker;
            _linker.delegate = (id)ctrl;
            _linker = nil;
            [self.navigationController pushViewController:ctrl
                                                 animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)linker:(LTLinker *)linker connectFaild:(NSError *)error
{
    
}

- (void)linker:(LTLinker *)linker receiveMessage:(NSData *)message from:(NSString *)name
{
    
}

- (void)linkerDisconnect:(LTLinker *)linker
{
    
}

- (void)linkerCancel:(LTLinker *)linker
{
    
}

@end
