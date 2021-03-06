//
//  LTLinker.h
//  LieTester
//
//  Created by zrz on 13-1-16.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LTUnknow,
    LTController,
    LTTester
} LTCharacter;

@protocol LTLinkerDelegate;

@interface LTLinker : NSObject

@property (nonatomic, assign) id<LTLinkerDelegate>  delegate;

// unused now.
@property (nonatomic, assign) NSInteger linkType;
@property (nonatomic, readonly) BOOL    connect;

- (void)disconnect;

- (void)startAsTester;
- (void)startAsController;

@property (nonatomic, assign)   BOOL    touching;

- (BOOL)send:(NSData *)data;

@end

@protocol LTLinkerDelegate <NSObject>

@optional
- (void)linker:(LTLinker *)linker connectSuccessWith:(NSString *)name;

- (void)linker:(LTLinker *)linker connectFaild:(NSError *)error;

- (void)linker:(LTLinker *)linker receiveMessage:(NSData *)message from:(NSString *)name;

- (void)linkerDisconnect:(LTLinker *)linker;

- (void)linkerCancel:(LTLinker *)linker;

@end