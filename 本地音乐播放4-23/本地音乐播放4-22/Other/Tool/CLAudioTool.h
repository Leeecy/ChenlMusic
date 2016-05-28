//
//  CLAudioTool.h
//  AVAudioPlayer
//
//  Created by chenl on 16/4/21.
//  Copyright © 2016年 sunsmart. All rights reserved.
//
/**
 *  管理播放属性
 *
 *  @param AVAudioPlayer <#AVAudioPlayer description#>
 *
 *  @return <#return value description#>
 */
#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
//  播放本地音乐\音效
@interface CLAudioTool : NSObject
/**
 *  播放音乐  播放成功 返回播放器
 *
 *  @param filename 音乐的文件名
 */
+ (AVAudioPlayer*)playMusic:(NSString *)filename;
/**
 *  暂停音乐
 *
 *  @param filename 音乐的文件名
 */
+ (void)pauseMusic:(NSString *)filename;
/**
 *  停止音乐
 *
 *  @param filename 音乐的文件名
 */
+ (void)stopMusic:(NSString *)filename;

/**
 *  播放音效
 *
 *  @param filename 音效的文件名
 */
+ (void)playSound:(NSString *)filename;
/**
 *  销毁音效
 *
 *  @param filename 音效的文件名
 */
+ (void)disposeSound:(NSString *)filename;
@end
