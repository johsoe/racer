//
//  RANetworkingManager.m
//  P2PRacer
//
//  Created by Johnny Sørensen on 07/04/14.
//  Copyright (c) 2014 heltsikkert. All rights reserved.
//

#import "RANetworkingManager.h"

@interface RANetworkingManager ()

@property (strong, nonatomic) MCPeerID *peerID;
@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCAdvertiserAssistant *assistant;
@property (strong, nonatomic) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (strong, nonatomic) MCNearbyServiceBrowser *serviceBrowser;
@property (strong, nonatomic) MCPeerID *remotePeerID;

@end

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
    NSLog(@"started assistant");
}
// lol
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
    
    self.serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerID discoveryInfo:nil serviceType:RAServiceType];

    self.serviceAdvertiser.delegate = self;
    
    if( self.isHost ) {
        self.assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:RAServiceType discoveryInfo:nil session:self.session];
        self.assistant.delegate = self;
        
        self.serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID serviceType:RAServiceType];
        self.serviceBrowser.delegate = self;
        [self.serviceBrowser startBrowsingForPeers];
        NSLog(@"startBrowsingForPeers...");
    }
    
    // We're a peer, start looking for hosts
    if( self.isHost == NO ) {

        [self.serviceAdvertiser startAdvertisingPeer];
        NSLog(@"Advertising as: %@", RAServiceType);
        
    }
    
//    [self.serviceAdvertiser startAdvertisingPeer];
    
//    self.assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:RAServiceType discoveryInfo:nil session:self.session];
//    self.serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID serviceType:RAServiceType];
}

#pragma mark - Host stuff

// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"lol");
    
    if( self.isHost ) {
        self.remotePeerID = peerID;
        
        // If peerID accepts it is added to the session
        [self.serviceBrowser invitePeer:peerID toSession:self.session withContext:nil timeout:15.0];
        NSLog(@"invited: %@", peerID);
    }
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    if ( [self.remotePeerID isEqual:peerID] ) {
        NSLog(@"Lost: %@ :)", peerID);
    }
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"ufedt");
}

#pragma mark - Peer

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"didNotStartAdvertisingPeer: %@", error);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context
 invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    self.remotePeerID = peerID;
    invitationHandler( YES, self.session );
    NSLog(@"Sending acceptance of invitation from: %@", peerID);
//    [self.serviceAdvertiser stopAdvertisingPeer];
}

#pragma mark - Session

// Remote peer changed state
- (void)session:(MCSession *)session
           peer:(MCPeerID *)peerID
 didChangeState:(MCSessionState)state
{
    NSLog(@"session -> didChangeState: %li", state);
    
    if ( state == MCSessionStateNotConnected ) {
        [self.serviceAdvertiser startAdvertisingPeer];
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session
 didReceiveData:(NSData *)data
       fromPeer:(MCPeerID *)peerID
{
    NSLog(@"didReceiveData from: %@", peerID);
    NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
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

#pragma mark - Sending

- (void)sendMessage:(NSString *)message
{
    if( self.remotePeerID == nil ) {
        NSLog(@"no remote peer to send message to :((");
    }
    
    NSError *error = nil;
    [self.session sendData:[message dataUsingEncoding:NSUTF8StringEncoding] toPeers:@[self.remotePeerID] withMode:MCSessionSendDataReliable error:&error];
    
    if( error != nil ) {
        NSLog(@"Error: %@", error);
    } else {
        NSLog(@"Worked!!!");
    }
    
}




@end
