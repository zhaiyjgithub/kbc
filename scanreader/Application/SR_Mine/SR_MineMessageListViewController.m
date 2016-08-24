//
//  SR_MineSendMessageViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/14.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageListViewController.h"
#import "globalHeader.h"
#import "SR_MineMessageListViewCell.h"
#import "SR_MineMessageSendViewController.h"
#import "UserInfo.h"
#import "httpTools.h"
#import "requestAPI.h"
#import "SR_MineMessageModel.h"
#import "AVRefreshExtension.h"

@interface SR_MineMessageListViewController ()
@property(nonatomic,assign)NSInteger messageListPageIndex;
@end

@implementation SR_MineMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的私信";
    self.tableView.av_footer = [AVFooterRefresh footerRefreshWithScrollView:self.tableView footerRefreshingBlock:^{
        [self loadData];
    }];

    [self getMessageList:PAGE_NUM pageIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"SR_MineMessageListViewCell";
    SR_MineMessageListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SR_MineMessageListViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    cell.messageModel = self.dataSource[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    SR_MineMessageSendViewController * sendVC = [[SR_MineMessageSendViewController alloc] init];
    [self.navigationController pushViewController:sendVC animated:YES];
    sendVC.messageModel = self.dataSource[indexPath.row];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)loadData{
    //先判断是否已经请求到最后一了。
    if (self.dataSource.count < PAGE_NUM * (self.messageListPageIndex + 1)) {
        SSLog(@"已经是最后一条数据了");
        [self.tableView.av_footer endFooterRefreshing];
    }else{
        [self getMessageList:PAGE_NUM pageIndex:self.messageListPageIndex + 1];
    }
}

///获取消息列表(包含了未读和已读消息)
- (void)getMessageList:(NSInteger)pageNum  pageIndex:(NSInteger)pageIndex{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"limit":limit,@"page":page,@"user_id":userId,@"user_token":userToken};
    [httpTools post:GET_MESSAGE_LIST andParameters:param success:^(NSDictionary *dic) {
        NSLog(@"messageList:%@",dic);
        NSArray * list = dic[@"data"][@"list"];
        for (NSDictionary * item in list) {
            SR_MineMessageModel * model = [SR_MineMessageModel modelWithDictionary:item];
            model.message_id = item[@"id"];
            model.sender.sender_id = item[@"sender"][@"id"];
            [self.dataSource addObject:model];
        }
        self.messageListPageIndex = (self.dataSource.count/PAGE_NUM) + (self.dataSource.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}



@end
