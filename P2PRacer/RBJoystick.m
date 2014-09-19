//
//  RBJoystick.m
//  Robeat Boys
//
//  Created by Kasper Welner on 7/16/13.
//  Copyright (c) 2013 Welner. All rights reserved.
//

#import "RBJoystick.h"
#if TARGET_IPHONE_SIMULATOR
#import "kbdclient.h"
#endif

@import CoreMotion;

@interface RBJoystick ()
@property (nonatomic, strong)CMMotionManager *motionManager;
@end

@implementation RBJoystick

- (void)reset
{
    self.jumpButtonIsHeld = NO;
    self.fireButtonIsHeld = NO;
    self.fireButtonHasBeenUsed = NO;
    self.joystickTouch = nil;
    self.jumpButtonTouch = nil;
    self.fireButtonTouch = nil;
}

#if (TARGET_IPHONE_SIMULATOR == 0)

- (id)init
{
    self = [super init];
    if (self) {
        self.motionManager = [[CMMotionManager alloc] init];
        [self.motionManager startAccelerometerUpdates];
    }
    return self;
}

- (CGFloat)direction
{
    CMAccelerometerData *data = self.motionManager.accelerometerData;
    return - data.acceleration.y;
}

#else

- (id)init
{
    self = [super init];
    if (self) {
        kbdclient_init("127.0.0.1", 53841);
    }
    return self;
}

- (CGFloat)direction
{
    if ( kbdclient_held(KEY_LEFT) ) {
        return + 0.5;
    } else if ( kbdclient_held(KEY_RIGHT) ) {
        return - 0.5;
    }
    
    return RBJoystickDirectionNeutral;
}

- (BOOL)jumpButtonIsHeld
{
    return kbdclient_held(KEY_UP);
}

- (void)setJumpButtonIsHeld:(BOOL)jumpButtonIsHeld
{}


- (BOOL)fireButtonIsHeld
{
    BOOL isSpacePressed =  kbdclient_held(32);

    if ( !isSpacePressed ) {
        self.fireButtonHasBeenUsed = NO;
    } else if ( self.fireButtonHasBeenUsed ) {
        return NO;
    }
    
    return isSpacePressed;
}


- (void)setFireButtonIsHeld:(BOOL)fireButtonIsHeld {}

- (void)setDirection:(RBJoystickDirection)direction
{}

#endif
@end
