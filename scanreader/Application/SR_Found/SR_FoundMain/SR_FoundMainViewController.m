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
#import "SR_FoundMainImageViewCell.h"
#import "SR_FoundMainVoiceViewCell.h"

#import "SR_MineSendMessageViewController.h"
#import "SR_FoundSearchTableViewController.h"

#import "globalHeader.h"

@interface SR_FoundMainViewController ()<addBtnDelegate,UISearchBarDelegate>
@property(nonatomic,assign)BOOL isSelectBookClubBtn;
@end

@implementation SR_FoundMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"发现";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(clickLeft)];
}

- (void)clickLeft{
     SR_FoundSearchTableViewController * vc = [[SR_FoundSearchTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 81;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 133;
    }else{
        return 143;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1) {
        NSString * cellId = @"SR_FoundMainVoiceViewCell";
        SR_FoundMainVoiceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_FoundMainVoiceViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        return cell;
    }else {
        NSString * cellId = @"SR_FoundMainImageViewCell";
        SR_FoundMainImageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_FoundMainImageViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        [cell addBlock:^{
            SSLog(@"click header btn");
        }];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 125)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView * headerNotiBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 36)];
    headerView.backgroundColor = kColor(227, 233, 233);
    [headerView addSubview:headerNotiBgView];
    
    UIImageView * headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 3, 30, 30)];
    headerImageView.layer.cornerRadius = 15;
    headerImageView.backgroundColor = [UIColor redColor];
    [headerView addSubview:headerImageView];
    
    UILabel * notiLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImageView.frame.origin.x + headerImageView.frame.size.width + 10, 0, kScreenWidth - 30 - 10 - headerImageView.frame.size.width, 36)];
    notiLabel.text = @"小明刚才扫描了《天龙八部》";
    notiLabel.textColor = [UIColor blackColor];
    notiLabel.font = [UIFont systemFontOfSize:14.0];
    notiLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:notiLabel];
    
    NSArray * titles = @[@"动态",@"读书会"];
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i*(kScreenWidth/2), notiLabel.frame.origin.y + notiLabel.frame.size.height, kScreenWidth/2, 42)];
        
        if (i == 0) {
            if (self.isSelectBookClubBtn) {//当前选中了动态按钮
                [btn setTitle:titles[i] forState:(UIControlStateNormal)];
                [btn setTitleColor:baseColor forState:(UIControlStateNormal)];
                btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
            }else{
                [btn setTitle:titles[i] forState:(UIControlStateNormal)];
                [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
            }
        }else{
            if (!self.isSelectBookClubBtn) {//当前选中了动态按钮
                [btn setTitle:titles[i] forState:(UIControlStateNormal)];
                [btn setTitleColor:baseColor forState:(UIControlStateNormal)];
                btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
            }else{
                [btn setTitle:titles[i] forState:(UIControlStateNormal)];
                [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
            }
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(clickHeaderBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [headerView addSubview:btn];
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, notiLabel.frame.size.height + notiLabel.frame.origin.y + 2, 1, 40)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineView];
    
    UIView * notiLabelBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, notiLabel.frame.origin.y + notiLabel.frame.size.height, kScreenWidth, 0.5)];
    notiLabelBottomLineView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:notiLabelBottomLineView];
    
    return headerView;
}

- (void)clickHeaderBtn:(UIButton *)btn{
    SSLog(@"btn tag:%d",btn.tag);
    self.isSelectBookClubBtn = !self.isSelectBookClubBtn;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    SSLog(@"search text:%@",searchText);
}

@end
