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

@interface RANetworkingManager : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>

@property (strong, nonatomic) MCPeerID *peerID;
@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCAdvertiserAssistant *assistant;

@end
