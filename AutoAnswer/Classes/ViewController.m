//
//  ViewController.m
//  AutoAnswer
//
//  Created by 金峰 on 2018/1/16.
//  Copyright © 2018年 金峰. All rights reserved.
//

#import "ViewController.h"
#import "AnswerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation ViewController

- (NSArray *)items {
    if (!_items) {
        _items = @[@"百万英雄（西瓜视频）",
                   @"冲顶大会",
                   @"百万赢家（花椒）",
                   @"芝士超人"];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundActive];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sj_cell_id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"sj_cell_id"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *item = [self.items objectAtIndex:indexPath.row];
    NSString *key;
    if ([item isEqualToString:@"百万英雄（西瓜视频）"]) {
        key = @"xigua";
    } else if ([item isEqualToString:@"冲顶大会"]) {
        key = @"cddh";
    } else if ([item isEqualToString:@"百万赢家（花椒）"]) {
        key = @"huajiao";
    } else {
        key = @"zscr";
    }
    
    AnswerViewController *answer = [[AnswerViewController alloc] init];
    answer.key = key;
    [self.navigationController pushViewController:answer animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"请在答题开始时进入对应的入口并退到后台，推荐答案将已推送的形式告知，请注意查看";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"⚠️ 答案并不一定准确，特别是题目为一些计算题，反问题，刁钻古怪的题目等。选择时请慎重考虑";
}

#pragma mark - 播放背景音乐 实现后台常驻

- (void)setBackgroundActive {
    
    //让 app 支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //播放背景音乐
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"wusheng" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    //创建播放器
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [self.audioPlayer prepareToPlay];
    
    //无限循环播放
    self.audioPlayer.numberOfLoops = -1;
    [self.audioPlayer play];
}


@end
