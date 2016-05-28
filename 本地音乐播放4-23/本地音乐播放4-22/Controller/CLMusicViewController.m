//
//  CLMusicViewController.m
//  本地音乐播放4-22
//
//  Created by chenl on 16/4/22.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 *  将选择跳转的歌曲装到工具类 管理音乐模型  
 *
 *  @param nonatomic <#nonatomic description#>
 *  @param strong    <#strong description#>
 *
 *  @return <#return value description#>
 */
#import "CLMusicViewController.h"
#import "CLMusicModel.h"
#import "MJExtension.h"
#import "CLMusicCell.h"
#import "CLMusicTool.h"
#import "CLPlayMusicController.h"
@interface CLMusicViewController ()
/**
 *
 */
@property (nonatomic,strong)CLPlayMusicController * playVC;
@end

@implementation CLMusicViewController
-(CLPlayMusicController *)playVC{
    if (!_playVC) {
        self.playVC = [[CLPlayMusicController alloc] init];
    }
    return _playVC;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark 初始化UI
-(void)configUI{
    

}
#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件

#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理

#pragma mark -
#pragma mark 业务逻辑

#pragma mark -
#pragma mark 通知注册和销毁

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [CLMusicTool musics].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLMusicCell *cell = [CLMusicCell cellWithTableView:tableView];
    cell.music = [CLMusicTool musics][indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.取消选中被点击的这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//   2 设置正在播放的歌曲  找到工具类要播放哪一首歌曲
    [CLMusicTool setPlayingMusic:[CLMusicTool musics][indexPath.row]];
//   3 显示播放界面  点击歌曲跳转到window窗口
    [self.playVC show];
}
@end






