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
#import "NSDate+JJ.h"
#import "SR_MineMessagePeopleModel.h"

#define MESSAGE_TYPE_SYSTEM @"2"
#define MESSAGE_TYPE_USER @"1"
#define MESSAGE_PAGE_NUM  1000

@interface SR_MineMessageListViewController ()<UIActionSheetDelegate>
@property(nonatomic,assign)NSInteger messageListPageIndex;
@property(nonatomic,strong)NSMutableArray * originalMessageList;
@property(nonatomic,strong)NSMutableArray * myAllMessageList;
@end

@implementation SR_MineMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"私信";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickRightBarItem)];
 
    [self getMessageList];
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
    cell.messagePeopleModel = self.dataSource[indexPath.row];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self deleteSessionMessages:self.dataSource[indexPath.row] row:indexPath.row];
//    }
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    SR_MineMessageSendViewController * sendVC = [[SR_MineMessageSendViewController alloc] init];
    sendVC.sender_id = [[self.dataSource[indexPath.row] sender] sender_id];
    sendVC.title = [[self.dataSource[indexPath.row] sender] username];
    [self.navigationController pushViewController:sendVC animated:YES];
}

- (void)getMessageList{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:@"/api/message/getPeopleList" andParameters:param success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray * list = dic[@"data"][@"list"];
        for (NSDictionary * item in list) {
            SR_MineMessagePeopleModel * peopleModel = [SR_MineMessagePeopleModel modelWithJSON:item];
            peopleModel.sender.sender_id = item[@"sender"][@"id"];
            NSLog(@"sender id:%@",peopleModel.sender.sender_id);
            [self.dataSource addObject:peopleModel];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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

//清空消息
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
          
            NSMutableArray * senderObjMessageList = senderObj[model.sender_id];
            [senderObjMessageList addObject:model];
            
            if ([model.sender.sender_id isEqualToString:userId]) {
                //本人发送的消息
                [self.myAllMessageList addObject:model];
            }
        }
        [senderObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            [self.dataSource addObject:obj];
        }];
        
        int i = 0;
        for (; i < self.dataSource.count; i ++) {
            SR_MineMessageModel * messageModel = [self.dataSource[i] firstObject];
            if ([messageModel.sender.sender_id isEqualToString:userId]) {
                break;
            }
        }
        if (i < self.dataSource.count) {
            [self.dataSource exchangeObjectAtIndex:0 withObjectAtIndex:i];
        }

        
        self.messageListPageIndex = (self.dataSource.count/MESSAGE_PAGE_NUM) + (self.dataSource.count%MESSAGE_PAGE_NUM > 0 ? 1 : 0);
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
