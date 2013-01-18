//
//  LTLinker.m
//  LieTester
//
//  Created by zrz on 13-1-16.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTLinker.h"
#import <GameKit/GameKit.h>
#import "LTData.h"


@interface LTLinker ()
<GKSessionDelegate, GKPeerPickerControllerDelegate>

@end

@implementation LTLinker
{
    GKSession   *_session;
    LTCharacter _type;
    NSString    *_linkingPeerID;
    dispatch_queue_t    _queue;
    GKPeerPickerController  *_peerPickerController;
}

- (id)init
{
    if (self = [super init]) {
        _queue = dispatch_queue_create("LINKER_QUEUE", NULL);
    }
    return self;
}

- (void)dealloc
{
}

- (void)showPeerPickerController {
    _peerPickerController = [[GKPeerPickerController alloc] init];
    _peerPickerController.delegate = self;
    [_peerPickerController show];
}

- (BOOL)send:(NSData *)data
{
    if (!_linkingPeerID) {
        return NO;
    }
    NSError *error = nil;
    [[self session] sendData:data
                     toPeers:@[_linkingPeerID]
                withDataMode:GKSendDataReliable
                       error:&error];
    if (error) {
        NSLog(@"False to send %@", error);
        return NO;
    }
    return YES;
}

- (void)setTouching:(BOOL)touching
{
    if (_touching == touching) {
        return;
    }
    _touching = touching;
    if (touching) {
        dispatch_async(_queue, ^{
            [self send:[LTData dataWithType:LTDataTypeTouchBegin].data];
        });
    }else {
        dispatch_async(_queue, ^{
            [self send:[LTData dataWithType:LTDataTypeTouchEnd].data];
        });
    }
}

- (void)startAsController
{
    _type = LTController;
    [self showPeerPickerController];
}

- (void)startAsTester
{
    _type = LTTester;
    [self showPeerPickerController];
}

- (void)disconnect
{
    _linkingPeerID = nil;
    _type = LTUnknow;
    [_session disconnectFromAllPeers];
    _connect = NO;
}

- (void)startWaitting
{
    [self performSelector:@selector(timeUp)
               withObject:nil
               afterDelay:100];
    [self showWaitting];
}

- (void)showWaitting
{
    
}

- (void)timeUp
{
    [_peerPickerController dismiss];
    if ([self.delegate respondsToSelector:@selector(linker:connectFaild:)]) {
        [self.delegate linker:self
                 connectFaild:[NSError errorWithDomain:@"Time out"
                                                  code:1224
                                              userInfo:nil]];
    }
}

#pragma mark - getter & setter

- (GKSession*)session
{
    if (!_session) {
        _session = [[GKSession alloc] initWithSessionID:nil
                                            displayName:nil
                                            sessionMode:GKSessionModePeer];
        _session.delegate = self;
        [_session setDataReceiveHandler:self withContext:nil];
    }
    return _session;
}

#pragma mark - session delegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state) {
        case GKPeerStateDisconnected:
            _connect = NO;
            if ([self.delegate respondsToSelector:@selector(linkerDisconnect:)]) {
                [self.delegate linkerDisconnect:self];
            }
            break;
            
        default:
            break;
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(linker:connectFaild:)]) {
        [self.delegate linker:self
                 connectFaild:error];
    }
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(linker:connectFaild:)]) {
        [self.delegate linker:self
                 connectFaild:error];
    }
}

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
          inSession:(GKSession *)session
            context:(void *)context
{
    if (![peer isEqualToString:_linkingPeerID]) {
        return;
    }
    LTData *trans = [[LTData alloc] initWithData:data];
    switch (trans.type) {
        case LTDataTypeAsk:
        {
            if (_type != LTTester) {
                return;
            }
            NSError *error = nil;
            [[self session] sendData:[LTData dataWithType:LTDataTypeReplyAsk].data
                             toPeers:@[peer]
                        withDataMode:GKSendDataReliable
                               error:&error];
            if (error) {
                NSLog(@"发送失败");
                if ([self.delegate respondsToSelector:@selector(linker:connectFaild:)]) {
                    [self.delegate linker:self
                             connectFaild:error];
                }
            }else {
                //连接成功
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                if ([self.delegate respondsToSelector:@selector(linker:connectSuccessWith:)]) {
                    NSString *name = [session displayNameForPeer:peer];
                    name = !name ? peer:name;
                    [self.delegate linker:self
                       connectSuccessWith:name];
                }
                _connect = YES;
            }
        }
            break;
            
        case LTDataTypeReplyAsk:
        {
            if (_type != LTController) {
                return;
            }
            //连接成功
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            if ([self.delegate respondsToSelector:@selector(linker:connectSuccessWith:)]) {
                NSString *name = [session displayNameForPeer:peer];
                name = !name ? peer:name;
                [self.delegate linker:self
                   connectSuccessWith:name];
            }
            _connect = YES;
        }
            break;
            
        default:
        {
            NSString *name = [session displayNameForPeer:peer];
            name = !name ? peer:name;
            if ([self.delegate respondsToSelector:@selector(linker:receiveMessage:from:)]) {
                [self.delegate linker:self
                       receiveMessage:data
                                 from:name];
            }
        }
            break;
    }
}

#pragma mark - peer ctrl delegate

- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type
{
    
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    return [self session];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    switch (_type) {
        case LTController:
        {
            //如果是控制器的话就发送询问
            [picker dismiss];
            _linkingPeerID = peerID;
            NSError *error = nil;
            LTData *data = [LTData dataWithType:LTDataTypeAsk];
            [[self session] sendData:data.data
                             toPeers:@[peerID]
                        withDataMode:GKSendDataReliable
                               error:&error];
            if (error) {
                //发送失败
                NSLog(@"发送失败");
            }else {
                //发送成功
                //等待 测试端 回复
                [self startWaitting];
            }
            break;
        }
        case LTTester:
            [picker dismiss];
            _linkingPeerID = peerID;
            [self startWaitting];
            break;
            
        default:
            break;
    }
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    if ([self.delegate respondsToSelector:@selector(linkerCancel:)]) {
        [self.delegate linkerCancel:self];
    }
}
@end
