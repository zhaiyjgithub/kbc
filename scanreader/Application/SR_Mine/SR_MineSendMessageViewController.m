//
//  SR_MineSendMessageViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/14.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineSendMessageViewController.h"
#import "SR_MineMessageHeaderInfoViewCell.h"
#import "SR_MineMessageSendTextViewViewCell.h"
#import "globalHeader.h"

@interface SR_MineSendMessageViewController ()

@end

@implementation SR_MineSendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TA";
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 68;
    }else{
        return 242;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString * cellId = @"SR_MineMessageHeaderInfoViewCell";
        SR_MineMessageHeaderInfoViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_MineMessageHeaderInfoViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        [cell addBlock:^{
            SSLog(@"cick headerIcon");
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        NSString * cellId = @"SR_MineMessageSendTextViewViewCell";
        SR_MineMessageSendTextViewViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_MineMessageSendTextViewViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        [cell addBlock:^(UITextView *textView) {
            SSLog(@"message:%@",textView.text);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}




@end
