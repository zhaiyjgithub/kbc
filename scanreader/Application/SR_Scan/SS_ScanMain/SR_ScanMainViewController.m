//
//  SR_ScanMainViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ScanMainViewController.h"
#import "SR_ScanResultHasBookViewController.h"
#import "SR_ScanResultNoneBookViewController.h"
#import "DDQRCodeViewController.h"
#import "globalHeader.h"

@implementation SR_ScanMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫描";
    
    UIButton * scanBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    scanBtn.frame = CGRectMake(0, 0, 100, 60);
    scanBtn.center = self.view.center;
    [scanBtn setTitle:@"扫一扫" forState:(UIControlStateNormal)];
    [scanBtn setTitleColor:baseColor forState:(UIControlStateNormal)];
    [scanBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [scanBtn addTarget:self action:@selector(clickScanBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:scanBtn];
}

- (void)clickScanBtn{
    self.hidesBottomBarWhenPushed = YES;
    DDQRCodeViewController * vc = [[DDQRCodeViewController alloc] initWithScanCompleteHandler:^(NSString *url) {
        NSLog(@"scan result:%@",url);
        
    }];
    vc.title = @"扫一扫";
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

@end
