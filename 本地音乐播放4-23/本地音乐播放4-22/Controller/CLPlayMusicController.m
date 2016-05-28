//
//  CLPlayMusicController.m
//  本地音乐播放4-22
//
//  Created by chenl on 16/4/22.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 *  封装音乐管理CLMusicTool类
 *
 *  @param weak      <#weak description#>
 *  @param nonatomic <#nonatomic description#>
 *
 *  @return <#return value description#>
 */

#import "CLPlayMusicController.h"
#import "UIView+Extension.h"
#import "CLMusicModel.h"
#import "CLMusicTool.h"
#import <AVFoundation/AVFoundation.h>
#import "CLAudioTool.h"
#import "CLLrcView.h"
#import "UIView+AutoLayout.h"
@interface CLPlayMusicController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (nonatomic, strong) CLMusicModel *musicModel;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIView *progressView;
//默认隐藏的中间button
@property (weak, nonatomic) IBOutlet UIButton *currentTimeView;
//滑块的值
@property (weak, nonatomic) IBOutlet UIButton *slider;
//进度条背景设置手势
- (IBAction)tapProgressBg:(UITapGestureRecognizer *)sender;
//滑块手势
- (IBAction)panSlider:(UIPanGestureRecognizer *)sender;

//音乐时长
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

- (IBAction)previous;
- (IBAction)next;
- (IBAction)playOrPause;
//词图切换
- (IBAction)lyricOrPic:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
/**
 *  播放进度定时器
 */
@property (nonatomic, strong) NSTimer *currentTimeTimer;

/**
 *  显示歌词的定时器
 */
@property (nonatomic, strong) CADisplayLink *lrcTimer;
@property (weak, nonatomic)  CLLrcView *lrcView;
//顶部view
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet UIButton *lyricOrPhotoBtn;

@end

@implementation CLPlayMusicController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLrcView];
    self.currentTimeView.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupLrcView
{
    CLLrcView *lrcView = [[CLLrcView alloc] init];
    self.lrcView = lrcView;
    lrcView.hidden = YES;
    [self.topView addSubview:lrcView];
    [lrcView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, - 50, 0)];
    [self.topView insertSubview:self.exitBtn aboveSubview:lrcView];
    [self.topView insertSubview:self.lyricOrPhotoBtn aboveSubview:lrcView];
}
-(void)show{
    // 0.禁用整个app的点击事件  拿到最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    不允许多次点击
    window.userInteractionEnabled = NO;
    // 1.添加播放界面
    self.view.frame = window.bounds;
    self.view.hidden = NO;
    [window addSubview:self.view];
    // 2.如果换了歌曲  如果换了歌曲清楚当前歌曲信息
    if (self.musicModel != [CLMusicTool playMusic]) {
        [self resetPlayingMusic];
    }
    
    // 3.动画显示
//页面从下往上跳转之前 y 值为页面高度  上个界面刚好隐藏
    self.view.y = self.view.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        // 开始播放音乐  整个页面显示之后才开始播放音乐
        [self startPlayingMusic];
         window.userInteractionEnabled = YES;
    }];
}
#pragma mark - 定时器处理
-(void)addCurrentTimeTimer{
    if (self.player.isPlaying == NO) return;
//    添加之前 移除之前的定时器 保证滑块正常
    [self removeCurrentTimeTimer];
    
    // 保证定时器的工作是及时的 滑块上面的时间即时显示
    [self updateCurrentTime];
    
    self.currentTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.currentTimeTimer forMode:NSRunLoopCommonModes];
}
//移除定时器
- (void)removeCurrentTimeTimer
{
    [self.currentTimeTimer invalidate];
    self.currentTimeTimer = nil;
}
/**
 *  更新播放进度
 */
- (void)updateCurrentTime{
    
    
     // 1.计算进度值
    double progress = self.player.currentTime / self.player.duration;
    // 2.设置滑块的x值
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    self.slider.x = sliderMaxX * progress;
//    设置滑块的时间
    [self.slider setTitle:[self strWithTime:self.player.currentTime] forState:(UIControlStateNormal)];
    NSLog(@"self.player.currentTime=%g",self.player.currentTime);
    // 3.设置进度条的宽度
    self.progressView.width = self.slider.center.x;
    
}


/**
 *  开始播放歌曲
 */
-(void)startPlayingMusic{
//    如果当前歌曲等于正在播放的歌曲 返回
    if (self.musicModel == [CLMusicTool playMusic]){
        [self addCurrentTimeTimer];
        [self addLrcTimer];
        return;
    }
    // 1.设置界面数据
//    当前正在播放的歌曲
    self.musicModel = [CLMusicTool playMusic];
    self.iconView.image = [UIImage imageNamed:self.musicModel.icon];
    self.singerLabel.text = self.musicModel.singer;
    self.songLabel.text = self.musicModel.name;
    // 2.开始播放
    self.player = [CLAudioTool playMusic:self.musicModel.filename];
    self.player.delegate = self;
    // 3.设置时长
    self.durationLabel.text = [self strWithTime:self.player.duration];
    
    // 4.开始定时器
    [self addCurrentTimeTimer];
    [self addLrcTimer];
    //    4.设置播放按钮状态
    self.playOrPauseButton.selected = YES;
//    5.切换歌词（加载新的歌词）
    self.lrcView.lrcname= self.musicModel.lrcname;
    
    
}
/**
 *  重置正在播放的音乐
 */
-(void)resetPlayingMusic{
    // 1.重置界面数据
    self.iconView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.singerLabel.text = nil;
    self.songLabel.text = nil;
    self.durationLabel.text = nil;
    // 2.停止播放
    [CLAudioTool stopMusic:self.musicModel.filename];
    self.player = nil;
    self.playOrPauseButton.selected = NO;
//    3 .停止定时器
    [self removeCurrentTimeTimer];
    [self removeLrcTimer];
    
    //清空歌词
    self.lrcView.lrcname = @"";
    self.lrcView.currentTime = 0;

    
//    4.设置播放按钮状态
    self.playOrPauseButton.selected = NO;
    
}
- (void)addLrcTimer
{
    if (self.lrcView.hidden == YES) return;
    
    if (self.player.isPlaying == NO && self.lrcTimer) {
        [self updateLrcTimer];
        return;
    }
    
    [self removeLrcTimer];
    
    [self updateLrcTimer];
    
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcTimer)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)updateLrcTimer
{
    self.lrcView.currentTime = self.player.currentTime;
}
- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}
#pragma mark - 私有方法
/**
 *  时长长度 -> 时间字符串
 */
- (NSString *)strWithTime:(NSTimeInterval)time
{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%d:%02d", minute, second];
}

#pragma mark -
#pragma mark 初始化UI

#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件
- (IBAction)exit {
    // 0.禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    防止用户再次点击
    window.userInteractionEnabled = NO;
    
    // 1.动画隐藏
    [UIView animateWithDuration:0.25 animations:^{
        self.view.y = self.view.height;
    } completion:^(BOOL finished) {
//        隐藏view 显示的时候不隐藏
        self.view.hidden = YES;
//        [self resetPlayingMusic];

        [self removeLrcTimer];
//        退出时让界面可以点击
        window.userInteractionEnabled = YES;
    }];

}

- (IBAction)playOrPause{
    if (self.playOrPauseButton.isSelected) {// 暂停
        self.playOrPauseButton.selected = NO;
        [CLAudioTool pauseMusic:self.musicModel.filename];
        [self removeCurrentTimeTimer];
        [self removeLrcTimer];
        
        
    }else {
        self.playOrPauseButton.selected = YES;
        [CLAudioTool playMusic:self.musicModel.filename];
        [self addCurrentTimeTimer];
        [self addLrcTimer];
    }
}

- (IBAction)lyricOrPic:(UIButton *)sender {
    
    if (self.lrcView.isHidden) {// 显示歌词，盖住图片
        self.lrcView.hidden = NO;
        sender.selected = YES;
        [self addLrcTimer];
    }else {// 隐藏歌词，显示图片
        self.lrcView.hidden = YES;
        sender.selected = NO;
        [self removeLrcTimer];
    }
    
}
- (IBAction)previous{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    // 1.重置当前歌曲
    [self resetPlayingMusic];
    //    2.获得下一首歌曲
    [CLMusicTool setPlayingMusic:[CLMusicTool previousMusic]];
    
    //    3.播放下一首
    [self startPlayingMusic];
    window.userInteractionEnabled = YES;
}
- (IBAction)next {
//    防止点击过快
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    // 1.重置当前歌曲
    [self resetPlayingMusic];
//    2.获得下一首歌曲
    [CLMusicTool setPlayingMusic:[CLMusicTool nextMusic]];
    
//    3.播放下一首
    [self startPlayingMusic];
    window.userInteractionEnabled = YES;
    
}
//点击了进度条背景
- (IBAction)tapProgressBg:(UITapGestureRecognizer *)sender {
//    点击的位置
    CGPoint point = [sender locationInView:sender.view];
    // 切换歌曲的当前播放时间  点击的x 除以view的宽度
    self.player.currentTime = (point.x / self.view.width)*self.player.duration;
    [self updateCurrentTime];
    
}

- (IBAction)panSlider:(UIPanGestureRecognizer *)sender {
   
    // 获得挪动的距离  x的值不变
    CGPoint t = [sender translationInView:sender.view];
    NSLog(@"sender.view = %@",sender.view);
    //    清空挪动的距离
    [sender setTranslation:CGPointZero inView:sender.view];
  
    // 控制滑块和进度条的frame  来控制歌曲
    
    
        //    设置时间值
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    self.slider.x += t.x;
    if (self.slider.x < 0) {
        self.slider.x = 0;
    }else if (self.slider.x > sliderMaxX){
        self.slider.x = sliderMaxX;
    }

    //    蓝色控制条拖动 等于滑块中点的x值
    self.progressView.width = self.slider.center.x;
    
        //    获取拖动的范围
    double progress = self.slider.x / sliderMaxX;
    //    拖动显示在滑块上面的时间
    NSTimeInterval time = self.player.duration * progress;
    [self.slider setTitle:[self strWithTime:time] forState:(UIControlStateNormal)];
    
    //    显示半透明指示器的文字
    [self.currentTimeView setTitle:self.slider.currentTitle forState:(UIControlStateNormal)];
    //    手动设置约束
    self.currentTimeView.x = self.slider.x;
    self.currentTimeView.hidden = NO;
    self.currentTimeView.y = self.currentTimeView.superview.height - 5 -self.currentTimeView.height;
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        //        停止定时器
        [self removeCurrentTimeTimer];
        [self removeLrcTimer];
//        手松开
    }else if (sender.state == UIGestureRecognizerStateEnded){
//        设置播放器的时间
        self.player.currentTime = time;
        [self addCurrentTimeTimer];
        [self addLrcTimer];
//        隐藏指示器
        self.currentTimeView.hidden = YES;
    }
   
}


#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理
/**
 *  播放器播放完毕调用

 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self next];
}
/**
 *  当播放器遇到终端的时候调用（来电）
 *
 *  @param player
 */
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    if (self.player.isPlaying) {
        [self playOrPause];
    }
}
/**
 *  电话结束
 */
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player{
    
}
#pragma mark -
#pragma mark 业务逻辑

#pragma mark -
#pragma mark 通知注册和销毁

@end










