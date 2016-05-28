//
//  CLLrcView.m
//  本地音乐播放4-22
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 chenl. All rights reserved.
//
/**
 *  1.歌词为一个tableView 由于xib不能设置initWithFrame 所以用ecode 在通过storyboard初始化时本身就不会执行initWithFrame .它会执行initWithNib, initWithCoder, awakFromNib 等方法，而继承自UIView的控件在初始时会调用 initWithFrame方法。
 重写initWithCoder 方法。在使用storyboard或xib时，这个方法会被调用。
 *
 *  @return <#return value description#>
 */
#import "CLLrcView.h"
#import "CLLrcCell.h"
#import "UIView+Extension.h"
#import "CLLrcLine.h"
#import "UIView+AutoLayout.h"
@interface CLLrcView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *lrcLineArr;
@property (nonatomic, assign) int currentIndex;
@end
@implementation CLLrcView

-(NSMutableArray *)lrcLineArr{
    if (_lrcLineArr == nil) {
        self.lrcLineArr = [[NSMutableArray alloc]init];
        
    }
    return _lrcLineArr;
}
#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
-(void)setup{
    self.userInteractionEnabled = YES;
    self.image = [UIImage imageNamed:@"28131977_1383101943208.jpg"];
    self.contentMode = UIViewContentModeScaleToFill;
    self.clipsToBounds = YES;
    // 1.添加表格控件
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.tableView = tableView;
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0, self.tableView.height * 0.5, 0);
}
#pragma mark - 公共方法
#pragma mark - 公共方法
-(void)setLrcname:(NSString *)lrcname{
    _lrcname = [lrcname copy];
    // 0.清空之前的歌词数据
    [self.lrcLineArr removeAllObjects];
    //    加载歌词文件
    NSURL *url = [[NSBundle mainBundle]URLForResource:lrcname withExtension:nil];
    
    NSString *lrcStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //    全部歌词 分组
    NSArray *lrcCmps = [lrcStr componentsSeparatedByString:@"\n"];
    NSLog(@"lrcCmps=%@",lrcCmps);
    // 2.输出每一行歌词
    for (NSString *lrcCmp in lrcCmps) {
        CLLrcLine *line = [[CLLrcLine alloc]init];
        
        if (![lrcCmp hasPrefix:@"["]) continue ;
        // 如果是歌词的头部信息（歌名、歌手、专辑）
        if ([lrcCmp hasPrefix:@"[ti:"] || [lrcCmp hasPrefix:@"[ar:"] || [lrcCmp hasPrefix:@"[al:"] ){
            //            componentsSeparatedByString:@":" :分割
            NSString *word = [[lrcCmp componentsSeparatedByString:@":"] lastObject];
            //            substringToIndex:word.length - 1 截取到word.length - 1这个位置
            line.word = [word substringToIndex:word.length - 1];
            NSLog(@"word = %@",word);
            
        }else{// 非头部信息
            //            [00:03.74]Yeah-eh-heah  array =[[00:03.74,Yeah-eh-heah]
            NSArray *array = [lrcCmp componentsSeparatedByString:@"]"];
            //         substringFromIndex:1   从第一个元素开始截取 [00:03.74
            line.time = [[array firstObject] substringFromIndex:1];
            line.word = [array lastObject];
            NSLog(@"word = %@",line.word);
            
        }
        [self.lrcLineArr addObject:line];
    }
    [self.tableView reloadData];
    
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    //
    if (currentTime < _currentTime) {
        self.currentIndex = -1;
    }
    
    _currentTime = currentTime;
    
    int minute = currentTime / 60;
    int second = (int)currentTime % 60;
    int msecond = (currentTime - (int)currentTime) * 100;
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02d:%02d.%02d", minute, second, msecond];
    
    for (int idx = self.currentIndex + 1; idx<self.lrcLineArr.count; idx++) {
        CLLrcLine *currentLine = self.lrcLineArr[idx];
        // 当前模型的时间
        NSString *currentLineTime = currentLine.time;
        // 下一个模型的时间
        NSString *nextLineTime = nil;
        NSUInteger nextIdx = idx + 1;
        if (nextIdx < self.lrcLineArr.count) {
            CLLrcLine *nextLine = self.lrcLineArr[nextIdx];
            nextLineTime = nextLine.time;
        }
        
        // 判断是否为正在播放的歌词
        if (
            ([currentTimeStr compare:currentLineTime] != NSOrderedAscending)
            && ([currentTimeStr compare:nextLineTime] == NSOrderedAscending)
            && self.currentIndex != idx) {
            // 刷新tableView
            NSArray *reloadRows = @[
                                    [NSIndexPath indexPathForRow:self.currentIndex inSection:0],
                                    [NSIndexPath indexPathForRow:idx inSection:0]
                                    ];
            self.currentIndex = idx;
            [self.tableView reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationNone];
            
            
            // 滚动到对应的行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcLineArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLLrcCell *cell = [CLLrcCell cellWithTableView:tableView];
    cell.lrcLine = self.lrcLineArr[indexPath.row];
    
    if (self.currentIndex == indexPath.row) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    } else {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    
    return cell;
}



@end
