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


@interface SR_FoundSearchInterPageViewController ()<UISearchBarDelegate>
@property(nonatomic,strong)UISearchBar * searchBar;
@property(nonatomic,assign)NSInteger searchTag;
@property(nonatomic,assign)NSInteger searchPageIndex;

@end

@implementation SR_FoundSearchInterPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"cellid";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    cell.textLabel.text = @"-----";
    return cell;
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
    [self getListAll:PAGE_NUM pageIndex:self.searchPageIndex q:self.searchBar.text];
}

- (void)loadData{
    [self getListAll:PAGE_NUM pageIndex:self.searchPageIndex + 1 q:self.searchBar.text];
}

//笔记 /api/note/getList
//互动页 /api/page/getList
//书籍 /api/book/getList

///获取笔记以及收藏列表,这个列表就是动态的列表
- (void)getListAll:(NSInteger)pageNum pageIndex:(NSInteger)pageIndex q:(NSString *)q{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"limit":limit,@"page":page,@"q":q};
    [httpTools post:GET_PAGE_LIST andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"search note list:%@",dic);
        NSArray * list = dic[@"data"][@"list"];
        //区分不同类型的笔记进行不同model的转换
        //根据type 来区分笔记的类型
        //        1文字
        //        2图片
        //        3语音
        //        4收藏
//        for (NSDictionary * item in list) {
//            SR_BookClubBookNoteModel * noteModel = [SR_BookClubBookNoteModel modelWithDictionary:item];
//            noteModel.note_id = item[@"id"];
//            if ([item[@"book"] isKindOfClass:[NSDictionary class]]) {
//                noteModel.book.book_id = item[@"book"][@"id"];
//            }
//            noteModel.user.user_id = item[@"user"][@"id"];
//            [self.dataSource addObject:noteModel];
//        }
//        self.searchPageIndex = (self.dataSource.count/PAGE_NUM) + (self.dataSource.count%PAGE_NUM > 0 ? 1 : 0);
//        [self.tableView.av_footer endFooterRefreshing];
//        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}

@end
