//
//  SR_ScanResultHasBookViewController.m
//  scanreader
//
//  Created by admin on 16/7/23.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ScanResultHasBookViewController.h"
#import "globalHeader.h"
#import "httpTools.h"

@interface SR_ScanResultHasBookViewController ()
@property(nonatomic,strong)UIImageView * bookImageView;
@property(nonatomic,strong)UILabel * bookNameLabel;
@property(nonatomic,strong)UILabel * bookAuthorLabel;
@end

@implementation SR_ScanResultHasBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫码结果";
    [self setupBookView];
}

- (void)setupBookView{
    self.bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125, 150)];
    self.bookImageView.center = CGPointMake(kScreenWidth/2, 64 + 75 + sizeHeight(70));
    self.bookImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.bookImageView];
    
    self.bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bookImageView.frame.origin.y + self.bookImageView.frame.size.height + 15, kScreenWidth, 18)];
    self.bookNameLabel.text = @"书名:<<活着>>";
    self.bookNameLabel.textAlignment = NSTextAlignmentCenter;
    self.bookNameLabel.textColor = baseblackColor;
    self.bookNameLabel.font = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:self.bookNameLabel];
    
    self.bookAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bookNameLabel.frame.origin.y + self.bookNameLabel.frame.size.height + 15, kScreenWidth, 18)];
    self.bookAuthorLabel.text = @"作者:余华";
    self.bookAuthorLabel.textAlignment = NSTextAlignmentCenter;
    self.bookAuthorLabel.textColor = baseblackColor;
    self.bookAuthorLabel.font = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:self.bookAuthorLabel];
    
    UIButton * createBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    createBtn.frame = CGRectMake(15, self.bookAuthorLabel.frame.origin.y + self.bookAuthorLabel.frame.size.height + sizeHeight(100), kScreenWidth - 30, 58);
    [createBtn setBackgroundColor:baseColor];
    [createBtn setTitle:@"创建读书会" forState:(UIControlStateNormal)];
    [createBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [createBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    createBtn.layer.cornerRadius = 15.0;
    [createBtn addTarget:self action:@selector(clickCreateBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:createBtn];
}

- (void)clickCreateBtn{
    //
}


@end
