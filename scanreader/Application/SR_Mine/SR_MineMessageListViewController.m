//
//  SR_MineSendMessageViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/14.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageListViewController.h"
#import "globalHeader.h"

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
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}




@end
