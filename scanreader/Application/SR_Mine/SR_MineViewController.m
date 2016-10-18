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
#import <YYKit/YYKit.h>
#import "SR_ModifyNickNameViewController.h"
#import <SVProgressHUD.h>

@interface SR_MineViewController ()<UIActionSheetDelegate,modifyNickNameViewControllerDelegate>
@property(nonatomic,strong)UIImageView * headerImageView;
@end

@implementation SR_MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self getUserInfo];
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
        }else if (btn.tag == 100 || btn.tag == 101){
            NSString * isPublic = [UserInfo getUserPublic];
            if ([isPublic isEqualToString:@"1"]) {
                if (btn.tag == 101) {
                    [weakSelf updateUserInfo:@{@"public":@"2"}];
                }
            }else{
                if (btn.tag == 100) {
                    [weakSelf updateUserInfo:@{@"public":@"1"}];
                }
            }
        }
    }];
    cell.nameLabel.text = [NSString stringWithFormat:@"用户名称: %@",[UserInfo getUserName]];
    cell.levelabel.text = [NSString stringWithFormat:@"等级: %@级",[UserInfo getUserLevel]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
    headerView.backgroundColor = baseColor;
    
    UITapGestureRecognizer * bgViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateUserName)];
    [headerView addGestureRecognizer:bgViewGesture];
    
    YYAnimatedImageView * headerImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, 96, 96)];
    headerImageView.center = headerView.center;
    headerImageView.layer.cornerRadius = 46.0;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.borderWidth = 2.0;
    headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    headerImageView.userInteractionEnabled = YES;
    [headerView addSubview:headerImageView];
    [headerImageView setImageWithURL:[NSURL URLWithString:[UserInfo getUserAvatar]] placeholder:[UIImage imageNamed:@"headerIcon"]];
    self.headerImageView = headerImageView;
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderBtn)];
    [headerImageView addGestureRecognizer:gesture];
    
    return headerView;
}

- (void)updateUserName{
    self.hidesBottomBarWhenPushed = YES;
    SR_ModifyNickNameViewController * updateVC = [[SR_ModifyNickNameViewController alloc] init];
    updateVC.delegate = self;
    [self.navigationController pushViewController:updateVC animated:YES];
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
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"更改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[PhotoPickerTool sharedPhotoPickerTool] showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceTypeCamera) onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
            UIImage * scaleImage = [self scaleToSize:image size:CGSizeMake(192, 192)];
            self.headerImageView.image = scaleImage;
            [self updateHeaderImageView];
        } cancel:^{
            
        }];
    }else if (buttonIndex == 1){
        [[PhotoPickerTool sharedPhotoPickerTool] showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceTypePhotoLibrary) onViewController:self compled:^(UIImage *image, NSDictionary *editingInfo) {
            UIImage * scaleImage = [self scaleToSize:image size:CGSizeMake(192, 192)];
            self.headerImageView.image = scaleImage;
            [self updateHeaderImageView];
        } cancel:^{
            
        }];
    }
}

- (void)updateNickName{
    [self.tableView reloadData];
}

- (void)updateUserInfo:(NSDictionary *)info{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithDictionary: @{@"user_id":userId,@"user_token":userToken}];
    [param addEntriesFromDictionary:info];
    
    [httpTools post:UPDATE_USER_INFO andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"更新完毕");
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)updateHeaderImageView{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken};
    [httpTools uploadHeaderImage:UPDATE_USER_INFO parameters:param images:@[self.headerImageView.image] file:@"avatar" success:^(NSDictionary *dic) {
        if ([dic[@"status"] isEqualToString:@"-111"]){//你的账号已在其他地方登陆，请重新登陆
            [UIApplication sharedApplication].keyWindow.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController = [[SR_LoginViewController alloc] init];
            [SVProgressHUD showInfoWithStatus:@"你的账号已在其他地方登录，请重新登录"];
        }else{
            [self getUserInfo];
        }
        //更新成功之后重新请求个人信息
    } failure:^(NSError *error) {
        
    }];
}

- (void)getUserInfo{
    [httpTools post:GET_USER_INFO andParameters:@{@"id":[UserInfo getUserId]} success:^(NSDictionary *dic) {
        SSLog(@"dic:%@",dic);
        NSDictionary * userDic = dic[@"data"][@"record"];
        [UserInfo saveUserAvatarWith:userDic[@"avatar"]];
        [UserInfo saveUserIDWith:userDic[@"id"]];
        [UserInfo saveUserNameWith:userDic[@"username"]];
        [UserInfo saveUserLevelWith:userDic[@"level"]];
        [UserInfo saveUserCreditWith:userDic[@"credit"]];
        [UserInfo saveUserPublicWith:userDic[@"public"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)clickLoginOutBtn{
    SSLog(@"login out");
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken};
    [httpTools post:LOGIN_OUT andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"loginOut:%@",dic);
        NSString * mediaType = [UserInfo getUserMediaType];
        if ([mediaType isEqualToString:@"0"]) {
            [UserInfo saveUserPhoneNumberWith:@""];
            [UserInfo saveUserPasswordWith:@""];
            [UserInfo saveUserTokenWith:@""];
            [UserInfo saveUserIDWith:@""];
            [UserInfo saveUserAvatarWith:@""];
            [UserInfo saveUserNameWith:@""];
        }else{
            [UserInfo saveUserOpenIdWith:@""];
        }
        
        SR_LoginViewController * loginVC = [[SR_LoginViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
    } failure:^(NSError *error) {
        
    }];
}

///将UIImage缩放到指定大小尺寸：
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
