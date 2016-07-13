//
//  SR_OthersMineViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_OthersMineViewController.h"
#import "SR_OthersMineViewCell.h"
#import "globalHeader.h"

@interface SR_OthersMineViewController ()

@end

@implementation SR_OthersMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TA";
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 310;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 210.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"SR_OthersMineViewCell";
    SR_OthersMineViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SR_OthersMineViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    [cell addBlock:^(UITextView *textView) {
        SSLog(@"message:%@",textView.text);
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
    headerView.backgroundColor = baseColor;
    
    UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 92, 92)];
    headerBtn.center = headerView.center;
    headerBtn.backgroundColor = [UIColor redColor];
    headerBtn.layer.cornerRadius = 46.0;
    [headerView addSubview:headerBtn];
    return headerView;
}


@end
