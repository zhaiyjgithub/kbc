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
#import <MBProgressHUD.h>
#import <MJRefresh.h>

#define MESSAGE_TYPE_SYSTEM @"2"
#define MESSAGE_TYPE_USER @"1"

@interface SR_MineMessageListViewController ()<UIActionSheetDelegate>
@property(nonatomic,assign)NSInteger messageListPageIndex;
@property(nonatomic,strong)NSMutableArray * originalMessageList;
@end

@implementation SR_MineMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的私信";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickRightBarItem)];
    self.tableView.av_footer = [AVFooterRefresh footerRefreshWithScrollView:self.tableView footerRefreshingBlock:^{
        [self loadData];
    }];

    [self addHeaderRefresh];
    [self getMessageList:PAGE_NUM pageIndex:0];
}

- (void)addHeaderRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

- (void)loadNewData
{
    [self.originalMessageList removeAllObjects];
    [self.dataSource removeAllObjects];
    self.messageListPageIndex = 0;
    [self getMessageList:PAGE_NUM pageIndex:0];
}


- (void)clickRightBarItem{
    UIActionSheet * sheet =[[UIActionSheet alloc] initWithTitle:@"请选择要清空的消息类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"用户消息" otherButtonTitles:@"系统消息", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self clearAllMessageWithType:MESSAGE_TYPE_USER];
    }else if (buttonIndex == 1){
        [self clearAllMessageWithType:MESSAGE_TYPE_SYSTEM];
    }
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
    int unreadMessageCont = 0;
    NSArray * messageModelList = self.dataSource[indexPath.row];
    for (SR_MineMessageModel * messageModel in messageModelList) {
        if ([messageModel.readed isEqualToString:@"1"]) {//计算未读的数量
            unreadMessageCont +=1;
        }
    }
    SR_MineMessageModel * firstMessageModel= [self.dataSource[indexPath.row] lastObject];
    cell.unreadMessageCount = unreadMessageCont;
    cell.messageModel = firstMessageModel;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteSessionMessages:self.dataSource[indexPath.row] row:indexPath.row];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    SR_MineMessageSendViewController * sendVC = [[SR_MineMessageSendViewController alloc] init];
    [self.navigationController pushViewController:sendVC animated:YES];
    sendVC.messageModelsList = self.dataSource[indexPath.row];
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
        [self.originalMessageList removeAllObjects];
        [self.originalMessageList addObjectsFromArray:list];
        NSMutableSet * senderIdSet = [[NSMutableSet alloc] init];
        for (NSDictionary * item in list) {
            [senderIdSet addObject:item[@"sender_id"]];
        }
        NSMutableDictionary * senderObj = [NSMutableDictionary new];

        NSArray * senderIds = [senderIdSet allObjects];
        for (NSString * senderId in senderIds) {
            NSMutableArray * messageList = [NSMutableArray new];
            [senderObj setObject:messageList forKey:senderId];
        }
        for (NSDictionary * item in list) {
            SR_MineMessageModel * model = [SR_MineMessageModel modelWithDictionary:item];
            model.message_id = item[@"id"];
            model.sender.sender_id = item[@"sender"][@"id"];
            NSMutableArray * senderObjMessageList = senderObj[model.sender_id];
            [senderObjMessageList addObject:model];
        }
        [senderObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.dataSource addObject:obj];
        }];
        self.messageListPageIndex = (self.dataSource.count/PAGE_NUM) + (self.dataSource.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}

- (void)deleteSessionMessages:(NSArray *)messageList row:(NSInteger)row{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSMutableArray * messageIdList = [NSMutableArray new];
    for (SR_MineMessageModel * messageModel in messageList) {
        [messageIdList addObject:messageModel.message_id];
    }
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken,@"id":messageIdList};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:DELETE_SESSION_MESSAGE_LIST andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"delete message :%@",dic);
        [self.dataSource removeObjectAtIndex:row];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)clearAllMessageWithType:(NSString *)type{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken,@"create_by":type};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:CLEAR_ALL_MESSAGE andParameters:param success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSMutableArray * leftItems = [[NSMutableArray alloc] init];
        for (NSDictionary * messageItem in self.originalMessageList) {
            if (![messageItem[@"create_by"] isEqualToString:type]) {
                [leftItems addObject:messageItem];
            }
        }
        //重新分类并排序
        [self.originalMessageList removeAllObjects];
        self.originalMessageList = leftItems;
        [self.dataSource removeAllObjects];
        NSMutableSet * senderIdSet = [[NSMutableSet alloc] init];
        for (NSDictionary * item in self.originalMessageList) {
            [senderIdSet addObject:item[@"sender_id"]];
        }
        NSMutableDictionary * senderObj = [NSMutableDictionary new];
        
        NSArray * senderIds = [senderIdSet allObjects];
        for (NSString * senderId in senderIds) {
            NSMutableArray * messageList = [NSMutableArray new];
            [senderObj setObject:messageList forKey:senderId];
        }
        for (NSDictionary * item in self.originalMessageList) {
            SR_MineMessageModel * model = [SR_MineMessageModel modelWithDictionary:item];
            model.message_id = item[@"id"];
            model.sender.sender_id = item[@"sender"][@"id"];
            NSMutableArray * senderObjMessageList = senderObj[model.sender_id];
            [senderObjMessageList addObject:model];
        }
        [senderObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.dataSource addObject:obj];
        }];
        self.messageListPageIndex = (self.dataSource.count/PAGE_NUM) + (self.dataSource.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSMutableArray *)originalMessageList{
    if (!_originalMessageList) {
        _originalMessageList = [[NSMutableArray alloc] init];
    }
    return _originalMessageList;
}

@end
