//
//  CLMusicTool.m
//  本地音乐播放4-22
//
//  Created by mac on 16/4/22.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLMusicTool.h"
#import "MJExtension.h"
#import "CLMusicModel.h"
@implementation CLMusicTool
static NSArray *_musics;
static  CLMusicModel *_playingMusic;
/**
 *  返回所有的歌曲
 */
+ (NSArray *)musics
{
    if (!_musics) {
//        字典转模型
        _musics = [CLMusicModel mj_objectArrayWithFilename:@"Musics.plist"];
    }
    return _musics;
}
/**
 *  返回正在播放的歌曲
 */
+(CLMusicModel*)playMusic{
    return _playingMusic;

}
+(void)setPlayingMusic:(CLMusicModel *)playingMusic{
//   ！ [self musics] containsObject:playingMusic 传进来的音频无效不存在
    if (!playingMusic || ![[self musics] containsObject:playingMusic])return;
    if (_playingMusic == playingMusic) return ;
    _playingMusic = playingMusic;

}
/**
 *  下一首歌曲
 */
+ (CLMusicModel *)nextMusic{
    int nextIndex = 0;
//    当前播放歌曲
    if (_playingMusic) {
//        在数组中检索当前歌曲  indexOfObject
        int playingIndex = (int)[[self musics]indexOfObject:_playingMusic];
        nextIndex = playingIndex + 1;
        if (nextIndex >= [self musics].count) {
            nextIndex  = 0;
        }
    }
    return [self musics][nextIndex];

}

/**
 *  上一首歌曲
 */
+ (CLMusicModel *)previousMusic{
    int previousIndex = 0;
    //    当前播放歌曲
    if (_playingMusic) {
        //        在数组中检索当前歌曲
        int playingIndex = (unsigned)[[self musics]indexOfObject:_playingMusic];
        previousIndex = playingIndex -1;
        if (previousIndex < 0) {
            previousIndex  = (unsigned)[self musics].count -1;
        }
    }
    return [self musics][previousIndex];
}
@end















