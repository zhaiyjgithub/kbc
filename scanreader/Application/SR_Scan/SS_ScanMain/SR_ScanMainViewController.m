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

@implementation SR_ScanMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫描";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.hidesBottomBarWhenPushed = YES;
    SR_ScanResultNoneBookViewController * vc = [[SR_ScanResultNoneBookViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
