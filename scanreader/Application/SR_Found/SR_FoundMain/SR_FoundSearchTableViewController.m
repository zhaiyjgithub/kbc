//
//  SR_FoundSearchTableViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/18.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundSearchTableViewController.h"
#import "globalHeader.h"
#import "requestAPI.h"
#import "httpTools.h"
#import "SR_BookClubBookNoteModel.h"
#import "AVRefreshExtension.h"
#import "UserInfo.h"

@interface SR_FoundSearchTableViewController ()<UISearchBarDelegate>
@property(nonatomic,strong)UISearchBar * searchBar;
@property(nonatomic,strong)UIView * backgroundView;
@property(nonatomic,assign)NSInteger searchTag;
@property(nonatomic,assign)NSInteger searchPageIndex;
@end

@implementation SR_FoundSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSerchBar];
    self.tableView.backgroundView = self.backgroundView;
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
    
    if (!self.searchTag) {//全局搜索
        
    }else{
        NSString * searchBarPlacHoleder = @"";
        if (self.searchTag == SEARCH_TYPE_NOTE) {
            searchBarPlacHoleder = @"搜索笔记";
        }else if (self.searchTag == SEARCH_TYPE_INTER_PAGE){
             searchBarPlacHoleder = @"搜索互动页";
        }else{
            searchBarPlacHoleder = @"搜索扫描";
        }
        self.searchBar.placeholder = searchBarPlacHoleder;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length) {
        self.backgroundView.hidden = YES;
    }else{
        self.backgroundView.hidden = NO;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"text:%@",searchBar.text);
    NSInteger searchTag = 0;
    if (!self.searchTag) {//全局搜索
        
    }else{
        if (self.searchTag == SEARCH_TYPE_NOTE) {
            
        }else if (self.searchTag == SEARCH_TYPE_INTER_PAGE){
            
        }else{
            
        }
    }
}

- (void)loadData{
    [self getListAll:PAGE_NUM pageIndex:self.searchPageIndex + 1];
}

///获取笔记以及收藏列表,这个列表就是动态的列表
- (void)getListAll:(NSInteger)pageNum pageIndex:(NSInteger)pageIndex{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSString * userId = [UserInfo getUserId];
    NSDictionary * param = @{@"user_id":userId,@"limit":limit,@"page":page,@"mode":@"1"};
    [httpTools post:GET_LIST_ALL andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"get lsit all:%@",dic);
        NSArray * list = dic[@"data"][@"list"];
        //区分不同类型的笔记进行不同model的转换
        //根据type 来区分笔记的类型
        //        1文字
        //        2图片
        //        3语音
        //        4收藏
        for (NSDictionary * item in list) {
            SR_BookClubBookNoteModel * noteModel = [SR_BookClubBookNoteModel modelWithDictionary:item];
            noteModel.note_id = item[@"id"];
            noteModel.book.book_id = item[@"book"][@"id"];
            noteModel.user.user_id = item[@"user"][@"id"];
            [self.dataSource addObject:noteModel];
        }
        self.searchPageIndex = (self.dataSource.count/PAGE_NUM) + (self.dataSource.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}


- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        CGFloat borader = (kScreenWidth - 100 - 56*3)*1.0/2;
        NSArray * images = @[@"ss_bj",@"ss_hdy",@"ss_sm"];
        NSArray * titles = @[@"笔记",@"互动页",@"扫描"];
        for (int i = 0; i < 3; i ++) {
            UIButton * icon = [UIButton buttonWithType:(UIButtonTypeCustom)];
            icon.frame = CGRectMake(50 + i*(56 + borader), 64 + 50, 56, 56);
            icon.backgroundColor = [UIColor whiteColor];
            [icon setImage:[UIImage imageNamed:images[i]] forState:(UIControlStateNormal)];
            icon.layer.cornerRadius = 28.0;
            icon.tag = i;
            [icon addTarget:self action:@selector(clickBackgroundIcon:) forControlEvents:(UIControlEventTouchUpInside)];
            [_backgroundView addSubview:icon];
            
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x, icon.frame.origin.y + icon.frame.size.height + 5, icon.frame.size.width, 18)];
            titleLabel.text = titles[i];
            titleLabel.textColor = baseColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:16.0];
            [_backgroundView addSubview:titleLabel];
        }

    }
    return _backgroundView;
}

- (void)clickBackgroundIcon:(UIButton *)icon{
    NSInteger searchTag = 0;
    if (icon.tag == 0) {
        searchTag = SEARCH_TYPE_NOTE;
    }else if (icon.tag == 1){
        searchTag = SEARCH_TYPE_INTER_PAGE;
    }else{
        searchTag = SEARCH_TYPE_SCAN;
    }
    self.hidesBottomBarWhenPushed = YES;
    SR_FoundSearchTableViewController * searchVC = [[SR_FoundSearchTableViewController alloc] init];
    searchVC.searchTag = searchTag;
    [self.navigationController pushViewController:searchVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


@end
