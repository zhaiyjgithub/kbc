//
//  SR_FoundSearchInterPageViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/8/22.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundSearchInterPageViewController.h"
#import "globalHeader.h"
#import "requestAPI.h"
#import "httpTools.h"
#import "SR_BookClubBookNoteModel.h"
#import "AVRefreshExtension.h"
#import "UserInfo.h"
#import <MBProgressHUD.h>
#import "SR_InterPageListModel.h"
#import "SR_InterPageListViewCell.h"
#import "SR_InterPageDetailViewController.h"

@interface SR_FoundSearchInterPageViewController ()<UISearchBarDelegate>
@property(nonatomic,strong)UISearchBar * searchBar;
@property(nonatomic,assign)NSInteger searchTag;
@property(nonatomic,assign)NSInteger searchPageIndex;
@end

@implementation SR_FoundSearchInterPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"互动页";
    [self setupSerchBar];
    self.tableView.av_footer = [AVFooterRefresh footerRefreshWithScrollView:self.tableView footerRefreshingBlock:^{
        [self loadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SR_InterPageDetailViewController * pageDetailVC = [[SR_InterPageDetailViewController alloc] init];
    pageDetailVC.pageListModel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:pageDetailVC animated:YES];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (void)setupSerchBar{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 44)];
    self.searchBar.tintColor = [UIColor blackColor];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
    self.searchBar.placeholder = @"搜索互动页";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"text:%@",searchBar.text);
    [self.searchBar resignFirstResponder];
    [self.dataSource removeAllObjects];
    [self getListAll:PAGE_NUM pageIndex:self.searchPageIndex q:self.searchBar.text];
}

- (void)loadData{
    if (self.dataSource.count < PAGE_NUM*(self.searchPageIndex + 1)) {
        SSLog(@"已经是最后一条数据了");
        [self.tableView.av_footer endFooterRefreshing];
    }else{
        [self getListAll:PAGE_NUM pageIndex:self.searchPageIndex + 1 q:self.searchBar.text];
    }
}

- (void)getListAll:(NSInteger)pageNum  pageIndex:(NSInteger)pageIndex q:(NSString *)q{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"limit":limit,@"page":page,@"q":q};
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
        self.searchPageIndex = (self.dataSource.count/PAGE_NUM) + (self.dataSource.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

@end
