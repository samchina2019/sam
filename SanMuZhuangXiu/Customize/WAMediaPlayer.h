//
//  WAMediaPlayer.h
//  SuiYangPartyBuilding
//
//  Created by LiuZhengli on 16/11/7.
//  Copyright © 2016年 com.henanunicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface WAMediaPlayer : NSObject <AVAudioPlayerDelegate>

- (void)playVideoWithURL:(NSURL *)fileURL inView:(UIView *)view;
- (void)playAudioWithURL:(NSURL *)fileURL;
- (void)playAudioWithData:(NSData *)data;
- (void)playSound;

/// stop media which is playing
- (void)stop;

@end
