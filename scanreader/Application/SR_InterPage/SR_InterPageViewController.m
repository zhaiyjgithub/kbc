//
//  SR_InterPageViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_InterPageViewController.h"

@interface SR_InterPageViewController ()

@end

@implementation SR_InterPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"互动页";
    UIWebView * view = [[UIWebView alloc]initWithFrame:self.view.frame];
    [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [self.view addSubview:view];
}




@end
