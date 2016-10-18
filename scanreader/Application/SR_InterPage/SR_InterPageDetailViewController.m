//
//  SR_InterPageDetailViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/8/30.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_InterPageDetailViewController.h"
#import <MBProgressHUD.h>
#import "SR_AddBtnView.h"
#import "SR_ActionSheetImageView.h"
#import "SR_ActionSheetTextView.h"
#import "SR_ActionSheetVoiceView.h"
#import "globalHeader.h"
#import "requestAPI.h"
#import "UserInfo.h"
#import "requestAPI.h"
#import "globalHeader.h"
#import "httpTools.h"
#import "ShareTool.h"

@interface SR_InterPageDetailViewController ()<UIWebViewDelegate,addBtnDelegate,textViewSendBtnDelegate,imageViewSendBtnDelegate,voiceViewSendBtnDelegate>
@property(nonatomic,strong)UIButton * floatBtn;
@end

@implementation SR_InterPageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"互动页详情";
    //http://www.colortu.com/page/show/id/互动页ID
    NSString * pageUrl = [NSString stringWithFormat:@"http://www.colortu.com/page/show/id/%@",self.pageListModel.pageId];
    UIWebView * webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pageUrl]]];
    webView.scrollView.backgroundColor = [UIColor whiteColor];
//    webView.delegate = self;
    [self.view addSubview:webView];
    
    [self.view addSubview:self.floatBtn];
}

///这里做的偶都是有对象的笔记，需要传入page_id
- (void)clickAddBtnView:(NSInteger)tag{
    if (tag == 0) {//收藏
        [self collectOnePage:self.pageListModel.pageId];
    }else if (tag == 1){//分享
        [ShareTool show];
    }else if (tag == 2) {
        SR_ActionSheetTextView * textView = [[SR_ActionSheetTextView alloc] initActionSheetWith:nil text:nil];
        textView.delegate = self;
        textView.page_id = self.pageListModel.pageId;
        textView.requestType = NOTE_REQUSERT_TYPE_SAVE_PAGE;
        [textView show];
    }else if (tag == 3){
        SR_ActionSheetImageView * imageView = [[SR_ActionSheetImageView alloc] initActionSheetWith:nil images:nil viewController:self];
        imageView.delegate = self;
        imageView.page_id = self.pageListModel.pageId;
        imageView.viewController = self;
        imageView.requestType = NOTE_REQUSERT_TYPE_SAVE_PAGE;
        [imageView show];
    }else if (tag == 4){
        SR_ActionSheetVoiceView * voiceView = [[SR_ActionSheetVoiceView alloc] initActionSheetWith:nil voices:nil viewController:self];
        voiceView.delegate = self;
        voiceView.page_id = self.pageListModel.pageId;
        voiceView.requestType = NOTE_REQUSERT_TYPE_SAVE_PAGE;
        [voiceView show];
    }
}

- (void)collectOnePage:(NSString *)pageId{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken,@"page_id":pageId,@"type":@"4"};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:SAVE_NOTE andParameters:param success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

///做没有对象的笔记，已经刷新了数据，有可能后台没有更新那么快
///这里发送通知通知首页更新
- (void)clickTextViewSendBtn:(NSString *)title text:(NSString *)text{
    SSLog(@"title:%@ content:%@",title,text);
    [[NSNotificationCenter defaultCenter] postNotificationName:SR_NOTI_CREATE_PAGE_NOTE object:nil userInfo:@{SR_NOTI_CREATE_PAGE_NOTE_KEY_1:@"SR_NOTI_CREATE_PAGE_NOTE_KEY_1"}];
}

- (void)clickImageViewSendBtn:(NSString *)title images:(NSArray *)images{
    SSLog(@"image title:%@",title);
    [[NSNotificationCenter defaultCenter] postNotificationName:SR_NOTI_CREATE_PAGE_NOTE object:nil userInfo:@{SR_NOTI_CREATE_PAGE_NOTE_KEY_1:@"SR_NOTI_CREATE_PAGE_NOTE_KEY_1"}];
}

- (void)clickVoiceViewSendBtn:(NSString *)title text:(NSString *)text{
    SSLog(@"voice title:%@",title);
    [[NSNotificationCenter defaultCenter] postNotificationName:SR_NOTI_CREATE_PAGE_NOTE object:nil userInfo:@{SR_NOTI_CREATE_PAGE_NOTE_KEY_1:@"SR_NOTI_CREATE_PAGE_NOTE_KEY_1"}];
}


- (void)clickFloatBtn{
    NSString * userPhone = [UserInfo getUserPhoneNumber];
    NSString * userPwd = [UserInfo getUserPassword];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    if ([[UserInfo getUserMediaType] isEqualToString:@"0"]) {
        param[@"username"] = userPhone;
        param[@"password"] = userPwd;
    }else{
        param[@"media"] = [UserInfo getUserMediaType];
        param[@"openid"] = [UserInfo getUserOpenId];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:LOGIN andParameters:param success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        SSLog(@"relogin:%@",dic);
        if ([dic[@"status"] isEqualToString:@"1"]) {
            NSDictionary * userDic = dic[@"data"][@"user"];
            [UserInfo saveUserAvatarWith:userDic[@"avatar"]];
            [UserInfo saveUserIDWith:userDic[@"id"]];
            [UserInfo saveUserTokenWith:dic[@"data"][@"user_token"]];
            [UserInfo saveUserNameWith:userDic[@"username"]];
            [UserInfo saveUserLevelWith:userDic[@"level"]];
            [UserInfo saveUserPublicWith:userDic[@"public"]];
            [UserInfo saveUserCreditWith:userDic[@"credit"]];
            [UserInfo saveUserPhoneNumberWith:userPhone];
            [UserInfo saveUserPasswordWith:userPwd];
            
            SR_AddBtnView * addBtnView = [[SR_AddBtnView alloc] initAlertViewWithType:SR_BTN_TYPE_SHARE];
            addBtnView.delegate = self;
            [addBtnView show];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (UIButton *)floatBtn{
    if (!_floatBtn) {
        _floatBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _floatBtn.frame = CGRectMake(0, 0, 65, 65);
        _floatBtn.center = CGPointMake(kScreenWidth - 5 - 33, kScreenHeight/2);
        [_floatBtn setImage:[UIImage imageNamed:@"add_note"] forState:(UIControlStateNormal)];
        [_floatBtn addTarget:self action:@selector(clickFloatBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _floatBtn;
}




@end
