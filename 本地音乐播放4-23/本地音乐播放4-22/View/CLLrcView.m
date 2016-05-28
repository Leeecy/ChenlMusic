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
@interface CLLrcView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *lrcLineArr;
@property (nonatomic, assign) int currentIndex;
@end
@implementation CLLrcView

-(NSMutableArray *)lrcLineArr{
    if (_lrcLineArr) {
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
    // 1.添加表格控件
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.tableView = tableView;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0, self.tableView.height * 0.5, 0);
}
#pragma mark - 公共方法
-(void)setLrcname:(NSString *)lrcname{
    _lrcname = [lrcname copy];
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
