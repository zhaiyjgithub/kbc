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
    if (tag == 0) {
        SR_ActionSheetTextView * textView = [[SR_ActionSheetTextView alloc] initActionSheetWith:nil text:nil];
        textView.delegate = self;
        textView.requestType = NOTE_REQUSERT_TYPE_SAVE_PAGE;
        [textView show];
    }else if (tag == 1){
        SR_ActionSheetImageView * imageView = [[SR_ActionSheetImageView alloc] initActionSheetWith:nil images:nil viewController:self];
        imageView.delegate = self;
        imageView.viewController = self;
        imageView.requestType = NOTE_REQUSERT_TYPE_SAVE_PAGE;
        [imageView show];
    }else{
        SR_ActionSheetVoiceView * voiceView = [[SR_ActionSheetVoiceView alloc] initActionSheetWith:nil voices:nil viewController:self];
        voiceView.delegate = self;
        voiceView.requestType = NOTE_REQUSERT_TYPE_SAVE_PAGE;
        [voiceView show];
    }
}



///做没有对象的笔记，已经刷新了数据，有可能后台没有更新那么快
- (void)clickTextViewSendBtn:(NSString *)title text:(NSString *)text{
    SSLog(@"title:%@ content:%@",title,text);
}

- (void)clickImageViewSendBtn:(NSString *)title images:(NSArray *)images{
    SSLog(@"image title:%@",title);
    
}

- (void)clickVoiceViewSendBtn:(NSString *)title text:(NSString *)text{
    SSLog(@"voice title:%@",title);
}


- (void)clickFloatBtn{
    SR_AddBtnView * addBtnView = [[SR_AddBtnView alloc] initAlertView];
    addBtnView.delegate = self;
    [addBtnView show];
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


//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}
//
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}





@end
