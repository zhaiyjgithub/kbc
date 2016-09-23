//
//  SR_MineMessageOpenUrlViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/9/23.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageOpenUrlViewController.h"

@interface SR_MineMessageOpenUrlViewController ()

@end

@implementation SR_MineMessageOpenUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    webView.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
}


@end
