//
//  SR_InterPageViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_InterPageViewController.h"
#import "globalHeader.h"
#import "requestAPI.h"
#import "httpTools.h"
#import <MBProgressHUD.h>
#import "SR_InterPageListModel.h"
#import "AVRefreshExtension.h"
#import "SR_InterPageListViewCell.h"
#import "SR_InterPageDetailViewController.h"

@interface SR_InterPageViewController ()
@property(nonatomic,assign)NSInteger pageListPageIndex;
@end

@implementation SR_InterPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"互动页";
    self.tableView.av_footer = [AVFooterRefresh footerRefreshWithScrollView:self.tableView footerRefreshingBlock:^{
        [self loadData];
    }];

    [self getPageList:PAGE_NUM pageIndex:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"SR_InterPageListViewCell";
    SR_InterPageListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SR_InterPageListViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    cell.pageListModel = self.dataSource[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)loadData{
    //这里还需要判断
    [self getPageList:PAGE_NUM pageIndex:self.pageListPageIndex];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    SR_InterPageDetailViewController * pageDetailVC = [[SR_InterPageDetailViewController alloc] init];
    pageDetailVC.pageListModel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:pageDetailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


- (void)getPageList:(NSInteger)pageNum  pageIndex:(NSInteger)pageIndex{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"limit":limit,@"page":page};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:GET_PAGE_LIST andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"page list:%@",dic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray * list = dic[@"data"][@"list"];
        for (NSDictionary * item in list) {
            SR_InterPageListModel * pageListmodel = [SR_InterPageListModel modelWithDictionary:item];
            pageListmodel.pageId = item[@"id"];
            [self.dataSource addObject:pageListmodel];
        }
        self.pageListPageIndex = (self.dataSource.count/PAGE_NUM) + (self.dataSource.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}



@end
