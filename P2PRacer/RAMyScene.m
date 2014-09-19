//
//  RAMyScene.m
//  P2PRacer
//
//  Created by Johnny Sørensen on 07/04/14.
//  Copyright (c) 2014 heltsikkert. All rights reserved.
//

#import "RAMyScene.h"
#import "RBJoystick.h"

@interface RAMyScene() <SKPhysicsContactDelegate>

@property (nonatomic, strong)SKSpriteNode *car;
@property (nonatomic, strong)SKEmitterNode *exhaust;

@property (nonatomic, strong)RBJoystick *joystick;
@end


@implementation RAMyScene

-(void)didMoveToView:(SKView *)view
{
        /* Setup your scene here */
    
    self.backgroundColor = [SKColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1.0];
    
    //        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    //
    //        myLabel.text = @"Hello, World!";
    //        myLabel.fontSize = 30;
    //        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
    //                                       CGRectGetMidY(self.frame));
    //
    //        [self addChild:myLabel];
    
    
    self.joystick = [[RBJoystick alloc] init];
    
    self.car = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    self.car.size = CGSizeMake(20, 20);
    self.car.anchorPoint = CGPointMake(0.5, 0.5);
    
    self.car.position = CGPointMake(self.size.width / 2, self.size.height / 2);
    self.car.physicsBody = [SKPhysicsBody bodyWithTexture:self.car.texture size:self.car.size];
    self.car.physicsBody.dynamic = NO;
//    self.physicsWorld.contactDelegate = self;
    self.car.zPosition = 10.0;
    [self addChild:self.car];
    
//    self.exhaust = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Smoke" ofType:@"sks"]];
//    [self addChild:self.exhaust];
//    self.exhaust.targetNode = self;
//    self.exhaust.particleLifetime = 1.0;
}

//- (void)didBeginContact:(SKPhysicsContact *)contact
//{
//    NSLog(@"DidBeginContact!");
//}

-(void)update:(CFTimeInterval)currentTime {
    
    static CGFloat lastTime;
    
    static CGFloat delta;
    
    delta = (currentTime - lastTime) * 60.0;
        
    static const CGFloat kRotationSpeed = 0.3;
    static const CGFloat kDriveSpeed = 3.5;
    
    self.car.zRotation = self.car.zRotation + (self.joystick.direction * kRotationSpeed * delta);
    
    CGVector direction = CGVectorMake(-sin(self.car.zRotation), cos(self.car.zRotation));
    CGPoint position = CGPointMake(self.car.position.x + (direction.dx * kDriveSpeed * delta), self.car.position.y + (direction.dy * kDriveSpeed * delta));
    
    position.x = MIN(MAX(self.car.size.width / 2, position.x), self.size.width - self.car.size.width / 2);
    position.y = MIN(MAX(self.car.size.height / 2, position.y), self.size.height - self.car.size.width / 2);

    self.car.position = position;
    
    self.exhaust.position = CGPointMake(self.car.position.x, self.car.frame.origin.y);
    self.exhaust.zRotation = self.car.zRotation;
//        NSLog(@"Direction: %@", NSStringFromCGVector(direction));

//    [self.physicsWorld enumerateBodiesAtPoint:self.car.position usingBlock:^(SKPhysicsBody *body, BOOL *stop) {
//        if ( body != self.physicsBody ) {
//            NSLog(@"Colliding body: %@", body.node.name);
//        }
//        
//
//    }];
    
    lastTime = currentTime;
}


@end
