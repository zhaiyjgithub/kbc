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
@interface SR_MineMessageListViewController ()

@end

@implementation SR_MineMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的私信";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
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
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    SR_MineMessageSendViewController * sendVC = [[SR_MineMessageSendViewController alloc] init];
    [self.navigationController pushViewController:sendVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}




@end
