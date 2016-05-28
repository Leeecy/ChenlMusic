//
//  CLLrcView.h
//  本地音乐播放4-22
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "DRNRealTimeBlurView.h"

@interface CLLrcView : UIImageView
/**
 *  歌词的文件名
 */
@property (nonatomic, copy) NSString *lrcname;
@property (nonatomic, assign) NSTimeInterval currentTime;
@end
