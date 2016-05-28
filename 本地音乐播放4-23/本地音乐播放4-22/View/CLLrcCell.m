//
//  CLLrcCell.m
//  本地音乐播放4-22
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLLrcCell.h"
#import "CLLrcLine.h"
@implementation CLLrcCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"lrc";
    CLLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CLLrcCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.frame = self.bounds;
    
}
-(void)setLrcLine:(CLLrcLine *)lrcLine{
    _lrcLine = lrcLine;
    self.textLabel.text = lrcLine.word;
}
@end
