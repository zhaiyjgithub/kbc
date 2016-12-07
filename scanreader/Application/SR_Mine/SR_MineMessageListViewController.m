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
@property(nonatomic,strong)NSMutableArray * myAllMessageList;
@end

@implementation SR_MineMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的私信";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickRightBarItem)];
    self.tableView.av_footer = [AVFooterRefresh footerRefreshWithScrollView:self.tableView footerRefreshingBlock:^{
        [self loadData];
    }];
    [self getMessageList:PAGE_NUM pageIndex:self.messageListPageIndex];
//    [self addHeaderRefresh];
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
    //先获取对方的所有发送消息 再挑选本人发送对方的消息，组成并分类
    SR_MineMessageModel * friednMessageModel = [self.dataSource[indexPath.row] firstObject];
    NSMutableArray * toFriendMessageModels = [[NSMutableArray alloc] init];
    for (SR_MineMessageModel * myMessageModel in self.myAllMessageList) {
        if ([myMessageModel.recipient.recipient_id isEqualToString:friednMessageModel.sender.sender_id]) {
            [toFriendMessageModels addObject:myMessageModel];
            myMessageModel.isMyAccount = YES;
        }
    }
    NSMutableArray * dialogModels = [[NSMutableArray alloc] init];
    [dialogModels addObjectsFromArray:toFriendMessageModels];
    [dialogModels addObjectsFromArray:self.dataSource[indexPath.row]];
    //    还要按时间排序
    sendVC.messageModelsList = dialogModels;
    [self.navigationController pushViewController:sendVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)loadData{
    [self getMessageList:PAGE_NUM pageIndex:self.messageListPageIndex + 1];
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
        [self.originalMessageList addObjectsFromArray:list];
        //数据源更新了
        [self.dataSource removeAllObjects];
        [self.myAllMessageList removeAllObjects];
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
        NSString * userId = [UserInfo getUserId];
        for (NSDictionary * item in self.originalMessageList) {
            SR_MineMessageModel * model = [SR_MineMessageModel modelWithDictionary:item];
            model.message_id = item[@"id"];
            model.sender.sender_id = item[@"sender"][@"id"];
            model.recipient.recipient_id = item[@"recipient"][@"id"];
            model.target.target_id = item[@"target"][@"id"];
            if ([model.sender.sender_id isEqualToString:userId]) {
                //本人的消息
                [self.myAllMessageList addObject:model];
            }else{
                NSLog(@"send_id %@",model.sender_id);
               NSMutableArray * senderObjMessageList = senderObj[model.sender_id];
                [senderObjMessageList addObject:model];
            }
        }
        [senderObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([userId isEqualToString:key]) {
                
            }else{
               [self.dataSource addObject:obj];
            }
            
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

//晴空消息
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
        //数据源改变了，重新请求数据
        [self.dataSource removeAllObjects];
        [self.myAllMessageList removeAllObjects];
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
        NSString * userId = [UserInfo getUserId];
        for (NSDictionary * item in self.originalMessageList) {
            SR_MineMessageModel * model = [SR_MineMessageModel modelWithDictionary:item];
            model.message_id = item[@"id"];
            model.sender.sender_id = item[@"sender"][@"id"];
            if ([model.sender.sender_id isEqualToString:userId]) {
                //本人发送的消息
                [self.myAllMessageList addObject:model];
            }else{
                NSMutableArray * senderObjMessageList = senderObj[model.sender_id];
                [senderObjMessageList addObject:model];
            }
        }
        [senderObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([userId isEqualToString:key]) {
                
            }else{
                [self.dataSource addObject:obj];
            }
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

- (NSMutableArray *)myAllMessageList{
    if (!_myAllMessageList) {
        _myAllMessageList = [[NSMutableArray alloc] init];
    }
    return _myAllMessageList;
}

@end
