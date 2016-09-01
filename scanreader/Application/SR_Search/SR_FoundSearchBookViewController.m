//
//  SR_FoundSearchBookViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/8/22.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundSearchBookViewController.h"
#import "globalHeader.h"
#import "requestAPI.h"
#import "httpTools.h"
#import "SR_BookClubBookNoteModel.h"
#import "AVRefreshExtension.h"
#import "UserInfo.h"
#import "SR_BookClubBookModel.h"
#import "SR_FoundMainDynamicViewCell.h"
#import "SR_FoundMainBookClubBookNoteListViewController.h"

@interface SR_FoundSearchBookViewController ()<UISearchBarDelegate>
@property(nonatomic,strong)UISearchBar * searchBar;
@property(nonatomic,assign)NSInteger searchTag;
@property(nonatomic,assign)NSInteger searchPageIndex;


@end

@implementation SR_FoundSearchBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"书籍";
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
    return 128;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"SR_FoundMainDynamicViewCell";
    SR_FoundMainDynamicViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SR_FoundMainDynamicViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    cell.bookModel = self.dataSource[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SR_FoundMainBookClubBookNoteListViewController * bookMarkListVC = [[SR_FoundMainBookClubBookNoteListViewController alloc] init];
    bookMarkListVC.bookModel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:bookMarkListVC animated:YES];
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
    
    self.searchBar.placeholder = @"搜索书籍";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"text:%@",searchBar.text);
    [self getListAll:PAGE_NUM pageIndex:self.searchPageIndex q:self.searchBar.text];
}

- (void)loadData{
    //[self getListAll:PAGE_NUM pageIndex:self.searchPageIndex + 1 q:self.searchBar.text];
    if (self.dataSource.count < PAGE_NUM*(self.searchPageIndex + 1)) {
        SSLog(@"已经是最后一条数据了");
        [self.tableView.av_footer endFooterRefreshing];
    }else{
        [self getListAll:PAGE_NUM pageIndex:self.searchPageIndex + 1 q:self.searchBar.text];
    }
    
}
///获取笔记以及收藏列表,这个列表就是动态的列表
- (void)getListAll:(NSInteger)pageNum pageIndex:(NSInteger)pageIndex q:(NSString *)q{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"limit":limit,@"page":page,@"q":q};
    [httpTools post:GET_BOOK_CLUB_LIST_ALL andParameters:param success:^(NSDictionary *dic) {
        NSLog(@"bookClub:%@",dic);
        NSArray * list = dic[@"data"][@"list"];
        for (NSDictionary * item in list) {
            SR_BookClubBookModel * model = [SR_BookClubBookModel modelWithDictionary:item];
            model.book_id = item[@"id"];
            [self.dataSource addObject:model];
        }
        self.searchPageIndex = (self.dataSource.count/PAGE_NUM) + (self.dataSource.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}

@end
