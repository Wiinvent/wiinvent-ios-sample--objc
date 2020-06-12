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

static NSInteger const SAMPLE_ACCOUNT_ID = 81;
static NSString * const SAMPLE_CHANNEL_ID = @"34";
static NSString * const SAMPLE_STREAM_ID = @"154";
static NSString * const SAMPLE_TOKEN = @"1";
static NSString * const SAMPLE_VOD_URL = @"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4";


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
        CGRect heightPlayer = CGRectMake(0, 0, self.view.frame.size.width, 250);
        

        
        
        NSURL *videoUrl = [NSURL URLWithString:SAMPLE_VOD_URL];
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:videoUrl];

        // Setup player.
        player = [AVPlayer playerWithPlayerItem:item];

        // Setup player view controller.
        playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        playerViewController.showsPlaybackControls = YES;
        playerViewController.view.frame = heightPlayer;

        // Add player view controller to main view.
        [self addChildViewController:playerViewController];
        [self.view addSubview:playerViewController.view];
       
       
        // Add player observers
        [WISDK monitorAVPlayerWithPlayer: player];
       
        // Attach config ready callback handler to use
        // stream sources paired in Broadcast Center.
        WISDK.onConfigReady = ^(WIConfigData *configData) {
            // Load first playable source from array.chann
            for (WIStreamSource* source in configData.sources) {
                if ([AVAsset assetWithURL:source.url].isPlayable) {
                    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:source.url];
                    [self->player replaceCurrentItemWithPlayerItem:item];
                    break;
                }
            }
        };
        
        WISDK.onVoted = ^(NSString * userId, NSString * channelId, NSString * streamId, NSString * entryId, NSString * entryName, NSString * eventName, NSString * packageName, NSInteger numPredictSame) {
      
            printf("voted nhe");
        };
        
        WISDK.onUserPurchase = ^(NSString * userId, NSString * productId) {
            printf("onUserPurchase");
            double delayInSeconds = 2.0;
                   dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                   dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        
                       [WISDK onUserPurchaseSuccessWithToken:@"1" productId: @"1"];
                   });
        };
        
    //    WISDK.onVoted = ^(NSString * userId, NSString * channelId, NSString * streamId, NSString * entryId,
    //                      NSString *
    //                      NSInteger numPredictSame) {
    //
    //    };
    //
    //    WISDK.onUserPurchase = ^(NSString * userId, NSString* productId) {
    //
    //    };
    //
        // CreatV overlay data object.
        WIOverlayData *overlayData = [[WIOverlayData alloc]
                                      initWithChannelId: SAMPLE_CHANNEL_ID
                                      streamId: SAMPLE_STREAM_ID
                                      thirdPartyToken: @"025e2286d574f18e362bcb1f54dda8124eb6ceba"
                                      accountId: SAMPLE_ACCOUNT_ID
                                      mappingType: MappingTypeTHIRDPARTY
                                      platform: nil
                                      env: EnvironmentDEV
                                      deviceType: DeviceTypePHONE
                                      debug: true];
        
        // Add overlays to player view.
        [WISDK addOverlaysToPlayerViewWithContainer:self.view frame: heightPlayer overlayData:overlayData];
        
        double delayInSeconds = 10.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             
            //[WISDK onUserPurchaseSuccessWithToken:@"1" productId: @"1"];
        });
       
}


@end
