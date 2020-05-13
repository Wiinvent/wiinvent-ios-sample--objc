//
//  ViewController.m
//  wiinvent-ios-sample-objective-c
//
//  Created by mcg-corp on 5/5/20.
//  Copyright © 2020 wiinvent. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WISDK/WISDK-Swift.h>

static NSInteger const SAMPLE_ACCOUNT_ID = 1;
static NSString * const SAMPLE_CHANNEL_ID = @"1";
static NSString * const SAMPLE_STREAM_ID = @"1";
static NSString * const SAMPLE_TOKEN = @"1";
static NSString * const SAMPLE_VOD_URL = @"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4";


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *videoUrl = [NSURL URLWithString:SAMPLE_VOD_URL];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:videoUrl];
 
    // Setup player.
    player = [AVPlayer playerWithPlayerItem:item];

    // Setup player view controller.
    playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    playerViewController.showsPlaybackControls = YES;
    playerViewController.view.frame = self.view.frame;
 
    // Add player view controller to main view.
    [self addChildViewController:playerViewController];
    [self.view addSubview:playerViewController.view];
    
    
    // Add player observers
    [WISDK monitorAVPlayerWithPlayer: player];
    
    // Attach config ready callback handler to use
    // stream sources paired in Broadcast Center.
    WISDK.onConfigReady = ^(WIConfigData *configData) {
      // Load first playable source from array.
      for (WIStreamSource* source in configData.sources) {
        if ([AVAsset assetWithURL:source.url].isPlayable) {
          AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:source.url];
          [self->player replaceCurrentItemWithPlayerItem:item];
          break;
        }
      }
    };
    
    WISDK.onVoted = ^(NSString * userId, NSString * channelId, NSString * streamId, NSString * entryId, NSInteger numPredictSame) {
        
    };
    
    WISDK.onUserPurchase = ^(NSString * userId, NSInteger productId) {
        
    };
    
    // CreatV overlay data object.
    WIOverlayData *overlayData = [[WIOverlayData alloc]
                                  initWithChannelId: SAMPLE_CHANNEL_ID
                                  streamId: SAMPLE_STREAM_ID
                                  thirdPartyToken: @"Token"
                                  accountId: SAMPLE_ACCOUNT_ID
                                  mappingType: MappingTypeTHIRDPARTY
                                  platform: nil
                                  env: EnvironmentDEV
                                  deviceType: DeviceTypePHONE
                                  debug: true];
     
     // Add overlays to player view.
     [WISDK addOverlaysToPlayerViewWithContainer:self.view overlayData:overlayData];
}


@end
