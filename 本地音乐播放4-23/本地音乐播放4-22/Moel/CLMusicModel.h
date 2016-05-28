//
//  CLMusicModel.h
//  本地音乐播放4-22
//
//  Created by chenl on 16/4/22.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMusicModel : NSObject
/**
 *  歌曲名字
 */
@property (copy, nonatomic) NSString *name;
/**
 *  歌曲大图
 */
@property (copy, nonatomic) NSString *icon;
/**
 *  歌曲的文件名
 */
@property (copy, nonatomic) NSString *filename;
/**
 *  歌词的文件名
 */
@property (copy, nonatomic) NSString *lrcname;
/**
 *  歌手
 */
@property (copy, nonatomic) NSString *singer;
/**
 *  歌手图标
 */
@property (copy, nonatomic) NSString *singerIcon;
@end
