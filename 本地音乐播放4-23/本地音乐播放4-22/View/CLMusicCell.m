//
//  CLMusicCell.m
//  本地音乐播放4-22
//
//  Created by mac on 16/4/22.
//  Copyright © 2016年 chenl. All rights reserved.
//

#import "CLMusicCell.h"
#import "CLMusicModel.h"
#import "Colours.h"
#import "UIImage+MJ.h"
@implementation CLMusicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"music";
    CLMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CLMusicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}
-(void)setMusic:(CLMusicModel *)music{
    _music = music;
    self.textLabel.text = music.name;
    self.detailTextLabel.text = music.singer;
    self.imageView.image = [UIImage circleImageWithName:music.singerIcon borderWidth:2 borderColor:[UIColor pinkColor]];
}
@end
