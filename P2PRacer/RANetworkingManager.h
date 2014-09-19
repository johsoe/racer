//
//  RANetworkingManager.h
//  P2PRacer
//
//  Created by Johnny Sørensen on 07/04/14.
//  Copyright (c) 2014 heltsikkert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "RAConstants.h"

@interface RANetworkingManager : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCAdvertiserAssistantDelegate>

@property (assign, nonatomic) BOOL isHost;

+ (RANetworkingManager *)sharedInstance;
- (void)start;
- (void)stop;
- (void)setup;

- (void)sendMessage:(NSString *)message;

@end
