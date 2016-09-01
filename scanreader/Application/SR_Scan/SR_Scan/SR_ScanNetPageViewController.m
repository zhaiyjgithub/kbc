//
//  SR_ScanNetPageViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/9/1.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ScanNetPageViewController.h"

@interface SR_ScanNetPageViewController ()

@end

@implementation SR_ScanNetPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    
    NSURL* requestUrl = [NSURL URLWithString:self.url];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:requestUrl];//创建NSURLRequest
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    [webView loadRequest:request];
}


@end
