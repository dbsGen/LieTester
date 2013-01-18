//
//  LTControllerViewController.m
//  LieTester
//
//  Created by zrz on 13-1-16.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTControllerViewController.h"
#import "LTData.h"

@interface LTControllerViewController ()
<LTLinkerDelegate>

@end

void sendFaild()
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:local(@"Send faild!")
                                                   delegate:nil
                                          cancelButtonTitle:local(@"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

@implementation LTControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)lieClicked:(id)sender
{
    if (![self.linker send:[LTData dataWithType:LTDataTypeLie].data]) {
        sendFaild();
    }
}

- (IBAction)tensionClicked:(id)sender
{
    if (![self.linker send:[LTData dataWithType:LTDataTypeTension].data]) {
        sendFaild();
    }
}

- (IBAction)resumeClicked:(id)sender
{
    if (![self.linker send:[LTData dataWithType:LTDataTypeResume].data]) {
        sendFaild();
    }
}

- (IBAction)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - linker delegate

- (void)linkerDisconnect:(LTLinker *)linker
{
    self.stateLabel.text = local(@"Disconnect");
}

- (void)linker:(LTLinker *)linker receiveMessage:(NSData *)message from:(NSString *)name
{
    LTData *data = [[LTData alloc] initWithData:message];
    switch (data.type) {
        case LTDataTypeTouchBegin:
            self.stateLabel.text = local(@"Pressing");
            break;
            
        case LTDataTypeTouchEnd:
            self.stateLabel.text = local(@"Loosen");
            break;
            
        default:
            break;
    }
}

@end
