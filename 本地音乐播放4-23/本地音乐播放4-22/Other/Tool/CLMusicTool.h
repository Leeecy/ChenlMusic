//
//  CLMusicTool.h
//  本地音乐播放4-22
//
//  Created by mac on 16/4/22.
//  Copyright © 2016年 chenl. All rights reserved.
//
//管理音乐数据（音乐模型）
#import <Foundation/Foundation.h>
@class CLMusicModel;
@interface CLMusicTool : NSObject
/**
 *  返回所有的歌曲
 */
+ (NSArray *)musics;

/**
 *  返回正在播放的歌曲
 */
+(CLMusicModel*)playMusic;
+ (void)setPlayingMusic:(CLMusicModel *)playingMusic;
/**
 *  下一首歌曲
 */
+ (CLMusicModel *)nextMusic;

/**
 *  上一首歌曲
 */
+ (CLMusicModel *)previousMusic;
@end
