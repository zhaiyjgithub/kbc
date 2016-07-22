//
//  SR_MineViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineViewController.h"
#import "SR_MineViewCell.h"
#import "globalHeader.h"
#import "SR_LoginViewController.h"
#import "SR_MineMessageListViewController.h"

@interface SR_MineViewController ()
@property(nonatomic,strong)UIButton * headerBtn;
@end

@implementation SR_MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 58 + 94;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 152;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"SR_MineViewCell";
    SR_MineViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SR_MineViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    __weak typeof(self) weakSelf = self;
    [cell addBlock:^(UIButton *btn) {
        if (btn.tag == 103) {
            SR_MineMessageListViewController * messageListVC = [[SR_MineMessageListViewController alloc] init];
            [weakSelf.navigationController pushViewController:messageListVC animated:YES
             ];
        }
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
    self.headerBtn = headerBtn;
    [headerBtn addTarget:self action:@selector(clickHeaderBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView addSubview:headerBtn];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton * loginOutBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    loginOutBtn.frame = CGRectMake(15, 48, kScreenWidth - 30, 58);
    loginOutBtn.backgroundColor = baseColor;
    loginOutBtn.layer.cornerRadius = 29;
    [loginOutBtn setTitle:@"退出登录" forState:(UIControlStateNormal)];
    [loginOutBtn addTarget:self action:@selector(clickLoginOutBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [footerView addSubview:loginOutBtn];

    return footerView;
}

- (void)clickHeaderBtn{
    SSLog(@"header btn");
}

- (void)clickLoginOutBtn{
    SSLog(@"login out");
    SR_LoginViewController * loginVC = [[SR_LoginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
}

@end
