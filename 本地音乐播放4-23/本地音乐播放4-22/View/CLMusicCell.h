//
//  CLMusicCell.h
//  本地音乐播放4-22
//
//  Created by mac on 16/4/22.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLMusicModel;
@interface CLMusicCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**
 *  音乐模型
 */
@property (nonatomic,strong)CLMusicModel * music;
@end
