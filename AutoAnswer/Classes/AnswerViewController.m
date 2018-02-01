//
//  AnswerViewController.m
//  AutoAnswer
//
//  Created by 金峰 on 2018/1/17.
//  Copyright © 2018年 金峰. All rights reserved.
//

#import "AnswerViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "AnswerTableViewCell.h"
#import "Topic.h"

@interface AnswerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation AnswerViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray arrayWithCapacity:12];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([self.key isEqualToString:@"xigua"]) {
        self.title = @"百万英雄";
    } else if ([self.key isEqualToString:@"huajiao"]) {
        self.title = @"百万赢家";
    } else if ([self.key isEqualToString:@"zscr"]) {
        self.title = @"芝士超人";
    } else {
        self.title = @"冲顶大会";
    }
    
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeatForRequest) userInfo:nil repeats:YES];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self requestSogou];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sj_answer_cell_id"];
    if (!cell) {
        cell = [[AnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sj_answer_cell_id"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.items.count > indexPath.row) {
        Topic *topic = self.items[indexPath.row];
        cell.topic = topic;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}


#pragma mark - sogou

- (void)repeatForRequest {
    [self requestSogou];
}

- (void)requestSogou {
    __weak typeof(self) weakSelf = self;
    [[SJNetworkHelper shared] getWithUrl:sogouUrl params:@{@"key":self.key} modelClass:[Topic class] fetchComplication:^(BOOL succeed, int code, id response, NSError *error) {
        if (succeed) {
            NSArray *items = response;
            // 获取最新的一题
            Topic *topic = items.lastObject;
            NSString *cd_id = ((Topic *)weakSelf.items.lastObject).cd_id;
            
            // 最新的题目和已经缓存下来的题目是否为同一个
            if (![cd_id isEqualToString:topic.cd_id]) {
                // 发送本地推送
                if (topic.result.length) { // 获取到结果再发送
                    [weakSelf sendLocalNotificationWithTopic:topic];
                    
                    // 显示最新的题目
                    [weakSelf.items addObject:topic];
                    
                    [weakSelf.tableView beginUpdates];
                    [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.items.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [weakSelf.tableView endUpdates];
                }
            } else {
                // 重复请求 不需要发推送
                
            }
        }
    }];
}





- (void)sendLocalNotificationWithTopic:(Topic *)topic  {
    if (@available(iOS 10.0, *)) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = topic.title;
        content.body = [NSString stringWithFormat:@"推荐答案：%@",topic.result];
        content.sound = [UNNotificationSound defaultSound];
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"KFGroupNotification" content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
            if (error == nil) {
                DELog(@"已成功加推送%@",notificationRequest.identifier);
            }
        }];
    } else {
        UILocalNotification *local = [UILocalNotification new];
        if (@available(iOS 8.2, *)) {
            local.alertTitle = topic.title;
        }
        local.alertBody = [NSString stringWithFormat:@"推荐答案：%@",topic.result];
        [[UIApplication sharedApplication] scheduleLocalNotification:local];
        [[UIApplication sharedApplication] presentLocalNotificationNow:local];
        
    }
}


@end
