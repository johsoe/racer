//
//  RBJoystick.h
//  Robeat Boys
//
//  Created by Kasper Welner on 7/16/13.
//  Copyright (c) 2013 Welner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RBJoystickDirectionNeutral = 0,
    RBJoystickDirectionLeft = 1,
    RBJoystickDirectionRight = 2
} RBJoystickDirection;

@interface RBJoystick : NSObject

@property(atomic, assign)CGPoint downPoint;
@property(readonly      )CGFloat direction;
@property(atomic, assign)BOOL jumpButtonIsHeld;
@property(atomic, assign)BOOL fireButtonIsHeld;
@property(atomic, assign)BOOL fireButtonHasBeenUsed;
@property(atomic, strong)UITouch *joystickTouch;
@property(atomic, strong)UITouch *jumpButtonTouch;
@property(atomic, strong)UITouch *fireButtonTouch;

- (void)reset;

@end
