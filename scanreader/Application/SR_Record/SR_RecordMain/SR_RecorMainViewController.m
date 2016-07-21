//
//  SR_RecorMainViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_RecorMainViewController.h"
#import "globalHeader.h"
#import "SR_FoundMainTextViewCell.h"
#import "SR_InterPageViewController.h"
#import "SR_FoundMainBookClubItemDetailViewController.h"
#import "SR_RecordMainTagButton.h"

@interface SR_RecorMainViewController ()
@property(nonatomic,assign)NSInteger selectedTagIndex;
@end

@implementation SR_RecorMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"记录";
    self.selectedTagIndex = 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 42;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedTagIndex == 0) {
        return 146;
    }else{
        return 64;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedTagIndex == 0) {
        NSString * cellId = @"SR_FoundMainTextViewCell";
        SR_FoundMainTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_FoundMainTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        [cell addBlock:^{
            SSLog(@"click header btn");
        }];
        return cell;
    }else{
        NSString * cellId = @"UITableViewCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellId];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.textColor = baseblackColor;
        if (self.selectedTagIndex == 1) {//扫描
            cell.textLabel.text = @"2016-07-28 14:00";
            cell.detailTextLabel.text = @"扫描了25页 天龙八部";
        }else{//收藏
            cell.textLabel.text = @"2016-07-28 14:00";
            cell.detailTextLabel.text = @"收藏了25页 论语";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 125)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        NSArray * images = @[@"re_jl_Pencil",@"re_jl_sm",@"re_jl_sc"];
        NSArray * titles = @[@"笔记",@"扫描",@"收藏"];
        for (int i = 0; i < 3; i ++) {
            SR_RecordMainTagButton * btn = [[SR_RecordMainTagButton alloc] initWithLength:kScreenWidth/3.0 height:42];
            btn.frame = CGRectMake(i*(kScreenWidth/3.0), 0, kScreenWidth/3, 42);
            [btn setTitle:titles[i] forState:(UIControlStateNormal)];
            [btn setTitleColor:baseColor forState:(UIControlStateSelected)];
            [btn setTitle:titles[i] forState:(UIControlStateSelected)];
            [btn setTitleColor:kColor(0x88, 0x88, 0x88) forState:(UIControlStateNormal)];
            [btn setImage:[UIImage imageNamed:images[i]] forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
            if (i == self.selectedTagIndex) {
                [btn setSelected:YES];
            }else{
                [btn setSelected:NO];
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(clickHeaderBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [headerView addSubview:btn];
        }
        for (int i = 0; i < 2; i ++) {
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake((i+1)*(kScreenWidth/3.0), 1, 0.5, 40)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [headerView addSubview:lineView];
        }
        
        return headerView;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedTagIndex == 0) {//笔记列表，跳转到详情
        SR_FoundMainBookClubItemDetailViewController * itemDetailVC = [[SR_FoundMainBookClubItemDetailViewController alloc] init];
        [self.navigationController pushViewController:itemDetailVC animated:YES];
    }else{//扫描、收藏
        SR_InterPageViewController * interPageVC = [[SR_InterPageViewController alloc] init];
        [self.navigationController pushViewController:interPageVC animated:YES];
    }
    
}

- (void)clickHeaderBtn:(UIButton *)btn{
    SSLog(@"tag:%d",btn.tag);
    self.selectedTagIndex = btn.tag;
    [self.tableView reloadData];
}

@end
