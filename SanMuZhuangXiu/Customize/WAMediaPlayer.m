//
//  WAMediaPlayer.m
//  SuiYangPartyBuilding
//
//  Created by LiuZhengli on 16/11/7.
//  Copyright © 2016年 com.henanunicom. All rights reserved.
//

#import "WAMediaPlayer.h"

@interface WAMediaPlayer()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAsset *avAsset;
@property (nonatomic, strong) AVPlayerItem *avPlayerItem;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;

@end

@implementation WAMediaPlayer

- (void)playVideoWithURL:(NSURL *)fileURL inView:(UIView *)view
{
    [self stop];
    
    _avAsset = [AVAsset assetWithURL:fileURL];
    _avPlayerItem = [[AVPlayerItem alloc] initWithAsset:_avAsset];
    _avPlayer = [[AVPlayer alloc] initWithPlayerItem:_avPlayerItem];
    _avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    [_avPlayerLayer setFrame:view.frame];
    [view.layer addSublayer:_avPlayerLayer];
    [_avPlayer seekToTime:kCMTimeZero];
    [_avPlayer play];
}


#pragma mark - Audio Support

- (void)playAudioWithURL:(NSURL *)fileURL
{
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    [self playAudioWithData:data];
}

- (void)playAudioWithData:(NSData *)data
{
    // set our default audio session state
    [self setSessionActiveWithMixing:NO];
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    
    [self setSessionActiveWithMixing:YES]; // YES == duck if other audio is playing
    [self playSound];
}

- (void)setSessionActiveWithMixing:(BOOL)duckIfOtherAudioIsPlaying
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    if ([[AVAudioSession sharedInstance] isOtherAudioPlaying] && duckIfOtherAudioIsPlaying)
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDuckOthers error:nil];
    }
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)playSound
{
    [self stop];
    if (self.audioPlayer && (self.audioPlayer.isPlaying == NO))
    {
        self.audioPlayer.delegate = self;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

/// stop media which is playing
- (void)stop
{
    if (self.audioPlayer && (self.audioPlayer.isPlaying == YES))
        [self.audioPlayer stop];
    if (_avPlayer) {
        [_avPlayer pause];
    }
}

@end
