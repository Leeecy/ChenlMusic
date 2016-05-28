//
//  CLLrcCell.h
//  本地音乐播放4-22
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLLrcLine;
@interface CLLrcCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) CLLrcLine *lrcLine;
@end
