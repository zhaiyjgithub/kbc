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
#import "PhotoPickerTool.h"
#import "httpTools.h"
#import "UserInfo.h"
#import <MBProgressHUD.h>
#import "UserInfo.h"

@interface SR_MineViewController ()<UIActionSheetDelegate>
@property(nonatomic,strong)UIImageView * headerImageView;
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
    cell.nameLabel.text = [NSString stringWithFormat:@"用户名称: %@",[UserInfo getUserName]];
    //cell.levelabel.text = [NSString stringWithFormat:@"用户等级:%@",[UserInfo ]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
    headerView.backgroundColor = baseColor;
    
    UIImageView * headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 92, 92)];
    headerImageView.center = headerView.center;
    headerImageView.layer.cornerRadius = 46.0;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.borderWidth = 2.0;
    headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    headerImageView.userInteractionEnabled = YES;
    [headerView addSubview:headerImageView];
    headerImageView.image = [UIImage imageNamed:@"headerIcon"];
    self.headerImageView = headerImageView;
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderBtn)];
    [headerImageView addGestureRecognizer:gesture];
    
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
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"更改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"拍照", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[PhotoPickerTool sharedPhotoPickerTool] showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceTypeCamera) onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
            self.headerImageView.image = image;
        }];
    }else if (buttonIndex == 1){
        [[PhotoPickerTool sharedPhotoPickerTool] showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceTypePhotoLibrary) onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
            self.headerImageView.image = image;
        }];
    }
}

- (void)clickLoginOutBtn{
    SSLog(@"login out");
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken};
    [httpTools post:LOGIN_OUT andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"loginOut:%@",dic);
        [UserInfo saveUserPhoneNumberWith:@""];
        [UserInfo saveUserPasswordWith:@""];
        [UserInfo saveUserTokenWith:@""];
        [UserInfo saveUserIDWith:@""];
        [UserInfo saveUserAvatarWith:@""];
        [UserInfo saveUserNameWith:@""];
        SR_LoginViewController * loginVC = [[SR_LoginViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
    } failure:^(NSError *error) {
        
    }];
    
}

@end
