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
#import <YYKit/YYKit.h>
#import "requestAPI.h"
#import "UserInfo.h"
#import "httpTools.h"
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>

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
    return 260.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"SR_OthersMineViewCell";
    SR_OthersMineViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SR_OthersMineViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    cell.userModel =  self.userModel;
    __weak typeof(self) weakSelf = self;
    [cell addBlock:^(UITextView *textView) {
        SSLog(@"message:%@",textView.text);
        [weakSelf sendMessage:weakSelf.userModel.user_id content:textView.text];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
    headerView.backgroundColor = baseColor;
    
    YYAnimatedImageView * headerImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, 92, 92)];
    headerImageView.center = headerView.center;
    [headerImageView setImageWithURL:[NSURL URLWithString:self.userModel.avatar] placeholder:[UIImage imageNamed:@"headerIcon"]];
    headerImageView.layer.cornerRadius = 46;
    headerImageView.layer.borderWidth = 2.0;
    headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    headerImageView.layer.masksToBounds = YES;
    [headerView addSubview:headerImageView];
    
    return headerView;
}

///发送消息
- (void)sendMessage:(NSString * )recipient_id content:(NSString *)content{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken,@"recipient_id":recipient_id,
                             @"content":content};
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud showAnimated:YES];
    [httpTools post:SEND_MESSAGE andParameters:param success:^(NSDictionary *dic) {
        [hud hideAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}


@end
