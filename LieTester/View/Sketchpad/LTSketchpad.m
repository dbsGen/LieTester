//
//  LTSketchpad.m
//  LieTester
//
//  Created by zrz on 13-1-17.
//  Copyright (c) 2013年 zrz(Gen). All rights reserved.
//

#import "LTSketchpad.h"
#import "cocos2d.h"
#import "LTBackground.h"
#import "LTTouch.h"
#import "CMUnistrokeRecognizer.h"
#import "CMUnistrokeRecognizerTypes.h"

#define kSize   CGSizeMake(190, 190)

@implementation LTSketchpad {
    LTBackground    *_backgroundLayer;
    CGPoint _oldPoint;
    LTTouch *_lastTouch;
    NSMutableArray  *_allTouches;
    UIBezierPath    *_gesturePath;
    CMURTemplatesRef    _gestureTempates;
    CMUROptionsRef      _options;
    
    UITouch     *_nowTouch;
}

@synthesize backgroundLayer = _backgroundLayer;

- (void)dealloc
{
    for (LTTouch *touch in _allTouches) {
        touch.missBlock = nil;
    }
    CMURTemplatesDelete(_gestureTempates);
    CMUROptionsDelete(_options);
}

- (id)init
{
    self = [super init];
    if (self) {
        _backgroundLayer = [LTBackground layerWithColor:ccc4(50, 255, 50, 255)
                                                  width:self.contentSize.width
                                                 height:self.contentSize.height];
        _backgroundLayer.position = CGPointMake(0, 0);
        [self addChild:_backgroundLayer];
        
        self.isTouchEnabled = YES;
        
        _allTouches = [[NSMutableArray alloc] init];
        
        _gesturePath = [[UIBezierPath alloc] init];
        
        
        NSArray *zArr = [NSArray arrayWithContentsOfFile:
                         [[NSBundle mainBundle] pathForResource:@"Z" ofType:@"plist"]];
        CMURPathRef path = CMURPathNewWithSize(zArr.count);
        //读取Z的模版
        for (NSString *ps in zArr) {
            CGPoint p = CGPointFromString(ps);
            CMURPathAddPoint(path, p.x, p.y);
        }
        
        _gestureTempates = CMURTemplatesNew();
        
        _options = CMUROptionsNew();
        _options->useProtractor = NO;
        _options->rotationNormalisationDisabled = NO;
        
        CMURTemplatesAdd(_gestureTempates,
                         "Z",
                         path,
                         _options);
        CMURPathDelete(path);
    }
    return self;
}

- (void)setPoint:(CGPoint)p
{
    if (CGPointEqualToPoint(p, _oldPoint)) {
        return;
    }
    //旧的消失
    GLubyte opacity = _lastTouch.opacity;
    float sx = _lastTouch.scaleX;
    float sy = _lastTouch.scaleY;
    [_lastTouch miss];
    
    //新的出现
    _oldPoint = p;
    _lastTouch = [LTTouch node];
    _lastTouch.position = p;
    _lastTouch.opacity = opacity;
    _lastTouch.scaleX = sx;
    _lastTouch.scaleY = sy;
    __unsafe_unretained LTSketchpad *this = self;
    _lastTouch.missBlock = ^(LTTouch *sender) {
        [this removeChild:sender cleanup:YES];
        [this->_allTouches removeObject:sender];
    };
    [_allTouches addObject:_lastTouch];
    [self addChild:_lastTouch];
    [_lastTouch show];
}

- (void)touchEnd
{
    for (LTTouch *touch in _allTouches) {
        [touch miss];
    }
    //验证手势
    CMURPathRef path = [self pathFromBezierPath:_gesturePath];
    CMURResultRef result = unistrokeRecognizePathFromTemplates(path, _gestureTempates, _options);
    if (result && strcmp(result->name, "Z") == 0 && result->score > 0.8) {
        if (self.backGestureBlock) {
            self.backGestureBlock(self);
        }
    }
    CMURResultDelete(result);
    
    _gesturePath = nil;
    CMURPathDelete(path);
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _gesturePath = [[UIBezierPath alloc] init];
    _nowTouch = [touches anyObject];
    CGPoint lp = [_nowTouch locationInView:[_nowTouch view]];
    CGPoint p = [[CCDirector sharedDirector] convertToGL:lp];
    [self setPoint:p];
    [_gesturePath moveToPoint:lp];
    
    if (self.touchBeginBlock) {
        self.touchBeginBlock(self);
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches containsObject:_nowTouch]) {
        CGPoint lp = [_nowTouch locationInView:[_nowTouch view]];
        CGPoint p = [[CCDirector sharedDirector] convertToGL:lp];
        [self setPoint:p];
        [_gesturePath addLineToPoint:lp];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchEnd];
    if (self.touchEndBlock) {
        self.touchEndBlock(self);
    }
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchEnd];
    if (self.touchEndBlock) {
        self.touchEndBlock(self);
    }
}

#pragma mark - gesture

- (CMURPathRef)pathFromBezierPath:(UIBezierPath *)bezierPath
{
    CMURPathRef path = CMURPathNew();
    CGPathApply(bezierPath.CGPath, path, CMURCGPathApplierFunc);
    
    return path;
}

static void
CMURCGPathApplierFunc(void *info, const CGPathElement *element)
{
    CMURPathRef path = (CMURPathRef)info;
    
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            CMURPathAddPoint(path, points[0].x, points[0].y);
            break;
            
        case kCGPathElementAddLineToPoint: // contains 1 point
            CMURPathAddPoint(path, points[0].x, points[0].y);
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            CMURPathAddPoint(path, points[0].x, points[0].y);
            CMURPathAddPoint(path, points[1].x, points[1].y);
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            CMURPathAddPoint(path, points[0].x, points[0].y);
            CMURPathAddPoint(path, points[1].x, points[1].y);
            CMURPathAddPoint(path, points[2].x, points[2].y);
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            break;
    }
}

@end
