//
//  SR_FoundMainViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundMainViewController.h"
#import "SR_LoginViewController.h"
#import "SR_MineViewController.h"
#import "SR_OthersMineViewController.h"
#import "SR_AddBtnView.h"

#import "globalHeader.h"

@interface SR_FoundMainViewController ()<addBtnDelegate>

@end

@implementation SR_FoundMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"发现";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(clickLeftBarItem)];
    
    UIView * sss = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    sss.center = self.view.center;
    sss.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sss];
}

- (void)clickLeftBarItem{
//    SR_OthersMineViewController * loginVC = [[SR_OthersMineViewController alloc] init];
//    [self.navigationController pushViewController:loginVC animated:YES];
    
    SR_AddBtnView * alertView = [[SR_AddBtnView alloc] initAlertView];
    alertView.delegate = self;
    [alertView show];
}

- (void)clickAddBtnView:(NSInteger)tag{
    SSLog(@"tag:%d",tag);
}

@end
