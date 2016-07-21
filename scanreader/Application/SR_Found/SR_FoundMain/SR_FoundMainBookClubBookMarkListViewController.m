//
//  SR_FoundMainDYnamicBookMarkListViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundMainBookClubBookMarkListViewController.h"
#import "globalHeader.h"
#import "SR_FoundMainVoiceViewCell.h"
#import "SR_FoundMainBookClubItemDetailViewController.h"

@interface SR_FoundMainBookClubBookMarkListViewController ()

@end

@implementation SR_FoundMainBookClubBookMarkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记列表";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 142;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"SR_FoundMainVoiceViewCell";
    SR_FoundMainVoiceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SR_FoundMainVoiceViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    [cell addBlock:^{
        SSLog(@"click header btn");
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SR_FoundMainBookClubItemDetailViewController * itemDetailVC = [[SR_FoundMainBookClubItemDetailViewController alloc] init];
    [self.navigationController pushViewController:itemDetailVC animated:YES];
}

@end
