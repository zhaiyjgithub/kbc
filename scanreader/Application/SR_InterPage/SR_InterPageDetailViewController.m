//
//  SR_InterPageDetailViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/8/30.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_InterPageDetailViewController.h"
#import <MBProgressHUD.h>
@interface SR_InterPageDetailViewController ()<UIWebViewDelegate>
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
