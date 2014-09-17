//
//  RANetworkingManager.m
//  P2PRacer
//
//  Created by Johnny Sørensen on 07/04/14.
//  Copyright (c) 2014 heltsikkert. All rights reserved.
//

#import "RANetworkingManager.h"

@implementation RANetworkingManager

static RANetworkingManager *sharedInstance;

+ (RANetworkingManager *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        
        sharedInstance = [[RANetworkingManager alloc] init];
        
    });
    
    return sharedInstance;
}


#pragma mark - State handling

- (void)stop
{
    [self.assistant stop];
}

- (void)start
{
    [self.assistant start];
}

- (void)restart
{
    [self stop];
    [self setup];
    [self start];
}

- (void)setup
{
    NSString *peerName = [[UIDevice currentDevice] name];
    
    self.peerID = [[MCPeerID alloc] initWithDisplayName:peerName];
    self.session = [[MCSession alloc]  initWithPeer:self.peerID];
    self.session.delegate = self;
    self.assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:RAServiceType discoveryInfo:nil session:self.session];
}

#pragma mark - advertiser

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context
 invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    
}

#pragma mark - Session

// Remote peer changed state
- (void)session:(MCSession *)session
           peer:(MCPeerID *)peerID
 didChangeState:(MCSessionState)state
{
    
}

// Received data from remote peer
- (void)session:(MCSession *)session
 didReceiveData:(NSData *)data
       fromPeer:(MCPeerID *)peerID
{

}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session
didReceiveStream:(NSInputStream *)stream
       withName:(NSString *)streamName
       fromPeer:(MCPeerID *)peerID
{

}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session
didStartReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MCPeerID *)peerID
   withProgress:(NSProgress *)progress
{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session
didFinishReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MCPeerID *)peerID
          atURL:(NSURL *)localURL
      withError:(NSError *)error
{
    
}

@end
