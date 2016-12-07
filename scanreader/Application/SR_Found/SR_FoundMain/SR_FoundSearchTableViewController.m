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
#import "SR_FoundSearchNoteViewController.h"
#import "SR_FoundSearchInterPageViewController.h"
#import "SR_FoundSearchBookViewController.h"

//笔记相关
#import "SR_FoundSearchNoteViewController.h"
#import "globalHeader.h"
#import "requestAPI.h"
#import "httpTools.h"
#import "SR_BookClubBookNoteModel.h"
#import "AVRefreshExtension.h"
#import "UserInfo.h"
#import "SR_FoundMainImageViewCell.h"
#import "SR_FoundMainVoiceViewCell.h"
#import "SR_FoundMainTextViewCell.h"
#import "SR_FoundMainTextSelfViewCell.h"
#import "SR_FoundMainImageSelfViewCell.h"
#import "SR_FoundMainVoiceSelfViewCell.h"
#import "SR_FoundMainTextSelfViewCell.h"
#import "SR_InterPageViewController.h"
#import "SR_FoundMainCollectionViewCell.h"
#import "SR_NoteDetailPageViewController.h"
#import "SR_OthersMineViewController.h"
#import "SR_MineViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MJRefresh.h>

//互动页
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

//书籍
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


@interface SR_FoundSearchTableViewController ()<UISearchBarDelegate>
@property(nonatomic,strong)UISearchBar * searchBar;
@property(nonatomic,strong)UIView * backgroundView;
@property(nonatomic,assign)NSInteger searchTag;
@property(nonatomic,assign)NSInteger searchPageIndex;

////////笔记相关
@property(nonatomic,assign)NSInteger noteSearchPageIndex;
@property(nonatomic,strong)AVPlayer * remotePlayer;
@property(nonatomic,assign)BOOL isFinishedPlay;
@property(nonatomic,strong)AVPlayerItem * playerItem;
@property(nonatomic,strong)NSMutableArray * noteList;
//////互动页
@property(nonatomic,assign)NSInteger interPageSearchPageIndex;
@property(nonatomic,strong)NSMutableArray * interPageList;
/////书籍
@property(nonatomic,assign)NSInteger bookSearchPageIndex;
@property(nonatomic,strong)NSMutableArray * bookList;

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.noteList.count + self.interPageList.count + self.bookList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.noteList.count) {
        //笔记
        SR_BookClubBookNoteModel * noteModel = self.noteList[indexPath.row];
        if ([noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {
            return 146;
        }else if ([noteModel.type isEqualToString:NOTE_TYPE_PIX]){
            return 180;
        }else{
            return 146;
        }
        
    }else if (indexPath.row >= self.noteList.count && indexPath.row < self.noteList.count + self.interPageList.count){
       //互动页
        return 120;
    }else{
        //书籍
        return 128;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.noteList.count) {
        //根据type 来区分笔记的类型
        //        1文字
        //        2图片
        //        3语音
        //        4收藏
        SR_BookClubBookNoteModel * noteModel = self.noteList[indexPath.row];
        if ([noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {//文字信息
            NSString * cellId = @"SR_FoundMainTextViewCell";
            SR_FoundMainTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            cell.noteModel = self.noteList[indexPath.row];
            __weak typeof(self) weakSelf = self;
            [cell addBlock:^{
                if ([noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {//自己的笔记跳转到自己的个人信息
                    SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                    [weakSelf.navigationController pushViewController:mineVC animated:YES];
                }else{
                    SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                    SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                    otherVC.userModel = noteModel.user;
                    [weakSelf.navigationController pushViewController:otherVC animated:YES];
                }
            }];
            return cell;
        }else if ([noteModel.type isEqualToString:NOTE_TYPE_PIX]){//图片
            NSString * cellId = @"SR_FoundMainImageViewCell";
            SR_FoundMainImageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainImageViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            cell.noteModel = self.noteList[indexPath.row];
            __weak typeof(self) weakSelf = self;
            [cell addBlock:^{
                if ([noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {//自己的笔记跳转到自己的个人信息
                    
                    SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                    [weakSelf.navigationController pushViewController:mineVC animated:YES];
                }else{
                    SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                    SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                    otherVC.userModel = noteModel.user;
                    [weakSelf.navigationController pushViewController:otherVC animated:YES];
                }
            }];
            return cell;
            
        }else if ([noteModel.type isEqualToString:NOTE_TYPE_VOICE]){//语音
            NSString * cellId = @"SR_FoundMainVoiceViewCell";
            SR_FoundMainVoiceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainVoiceViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            cell.noteModel = self.noteList[indexPath.row];
            __weak typeof(self) weakSelf = self;
            [cell addBlock:^{
                if ([noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {//自己的笔记跳转到自己的个人信息
                    SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                    [weakSelf.navigationController pushViewController:mineVC animated:YES];
                }else{
                    SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                    SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                    otherVC.userModel = noteModel.user;
                    [weakSelf.navigationController pushViewController:otherVC animated:YES];
                }
            }];
            [cell addInterBlock:^{
                SR_InterPageViewController * interPaageVC = [[SR_InterPageViewController alloc] init];
                [weakSelf.navigationController pushViewController:interPaageVC animated:YES];
            }];
            
            [cell addVoiceBtnBlock:^(NSString *voiceUrl,float voiceTimeLength) {
                [weakSelf playVoiceWithFilePath:voiceUrl row:indexPath.row voiceTimeLength:voiceTimeLength];
            }];
            return cell;
        }else{//收藏
            NSString * cellId = @"SR_FoundMainCollectionViewCell";
            SR_FoundMainCollectionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainCollectionViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            __weak typeof(self) weakSelf = self;
            [cell addBlock:^{
                if ([noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {//自己的笔记跳转到自己的个人信息
                    SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                    [weakSelf.navigationController pushViewController:mineVC animated:YES];
                }else{
                    SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                    SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                    otherVC.userModel = noteModel.user;
                    [weakSelf.navigationController pushViewController:otherVC animated:YES];
                }
            }];
            
            return cell;
        }
    }else if (indexPath.row >= self.noteList.count && indexPath.row < self.noteList.count + self.interPageList.count){
        //搜索互动页，
        NSString * cellId = @"SR_InterPageListViewCell";
        SR_InterPageListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_InterPageListViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.pageListModel = self.interPageList[indexPath.row - (self.noteList.count)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        //书籍
        NSString * cellId = @"SR_FoundMainDynamicViewCell";
        SR_FoundMainDynamicViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_FoundMainDynamicViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.bookModel = self.bookList[indexPath.row - (self.noteList.count + self.interPageList.count)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ///注意每个部分下标的分布
    if (indexPath.row < self.noteList.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SR_BookClubBookNoteModel * noteModel = self.noteList[indexPath.row];
        SR_NoteDetailPageViewController * noteDetailVC = [[SR_NoteDetailPageViewController alloc] init];
        noteDetailVC.noteModel = noteModel;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noteDetailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if (indexPath.row >= self.noteList.count && indexPath.row < self.noteList.count + self.interPageList.count){
        SR_InterPageDetailViewController * pageDetailVC = [[SR_InterPageDetailViewController alloc] init];
        pageDetailVC.pageListModel = self.interPageList[indexPath.row - (self.noteList.count)];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pageDetailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        SR_FoundMainBookClubBookNoteListViewController * bookMarkListVC = [[SR_FoundMainBookClubBookNoteListViewController alloc] init];
        bookMarkListVC.bookModel = self.bookList[indexPath.row - (self.noteList.count + self.interPageList.count)];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bookMarkListVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (void)playVoiceWithFilePath:(NSString *)filePath row:(int)row voiceTimeLength:(float)voiceTimeLength{
    static int lastRow = -1;
    if (lastRow != row) {
        if (lastRow != -1) {//如果不是第一次打开的就可以获取上一次的语音的cell
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
            SR_FoundMainVoiceViewCell * lastVoiceViewCell = (SR_FoundMainVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            UIView * progressView = lastVoiceViewCell.voiceProgressView;
            [progressView.layer removeAllAnimations];//清除上一次的动画
        }
        self.isFinishedPlay = NO;
        self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:filePath]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.playerItem];
        
        self.remotePlayer = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
        [self.remotePlayer play];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        SR_FoundMainVoiceViewCell * voiceViewCell = (SR_FoundMainVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        //
        voiceViewCell.voiceProgressView.backgroundColor = baseColor;
        CGRect voiceProgressViewFrame = voiceViewCell.voiceProgressView.frame;
        [UIView animateWithDuration:voiceTimeLength animations:^{
            voiceViewCell.voiceProgressView.frame = CGRectMake(voiceProgressViewFrame.origin.x, voiceProgressViewFrame.origin.y, voiceViewCell.barView.frame.size.width, voiceViewCell.barView.frame.size.height);
            voiceViewCell.voiceProgressView.backgroundColor = kColor(215, 215, 215);
        } completion:^(BOOL finished) {
            voiceViewCell.voiceProgressView.frame = CGRectMake(voiceViewCell.barView.frame.origin.x, voiceViewCell.barView.frame.origin.y, 1, voiceViewCell.barView.frame.size.height);
        }];
        
        lastRow = row;
    }else{
        //在这里查询当前播放的状态，如果在播放就停止，已经播放完毕之后就重新播放
        if (!self.isFinishedPlay) {//点击了正在播放就可以终止播放
            //停止当前的progressView动画
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            SR_FoundMainVoiceViewCell * currentVoiceViewCell = (SR_FoundMainVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            UIView * voiceProgressView = currentVoiceViewCell.voiceProgressView;
            [voiceProgressView.layer removeAllAnimations];
            
            [self.remotePlayer pause];
            self.isFinishedPlay = YES;
        }else{//已经完成播放的可以重新继续播放同一个语音
            self.isFinishedPlay = NO;
            self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:filePath]];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:self.playerItem];
            
            self.remotePlayer = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
            [self.remotePlayer play];
            
            //AVPlayerItem
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            SR_FoundMainVoiceViewCell * voiceViewCell = (SR_FoundMainVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            voiceViewCell.voiceProgressView.backgroundColor = baseColor;
            CGRect voiceProgressViewFrame = voiceViewCell.voiceProgressView.frame;
            [UIView animateWithDuration:voiceTimeLength animations:^{
                voiceViewCell.voiceProgressView.frame = CGRectMake(voiceProgressViewFrame.origin.x, voiceProgressViewFrame.origin.y, voiceViewCell.barView.frame.size.width, voiceViewCell.barView.frame.size.height);
                voiceViewCell.voiceProgressView.backgroundColor = kColor(215, 215, 215);
            } completion:^(BOOL finished) {
                voiceViewCell.voiceProgressView.frame = CGRectMake(voiceViewCell.barView.frame.origin.x, voiceViewCell.barView.frame.origin.y, 1, voiceViewCell.barView.frame.size.height);
            }];
        }
    }
}

- (void)playerItemDidReachEnd{
    NSLog(@"播放完毕");
    self.isFinishedPlay = YES;
}



- (void)setupSerchBar{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 44)];
    self.searchBar.tintColor = [UIColor blackColor];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length) {
        self.backgroundView.hidden = YES;
    }else{
        self.backgroundView.hidden = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self.dataSource removeAllObjects];
    NSLog(@"text:%@",searchBar.text);
    
    //请求笔记
    [self.noteList removeAllObjects];
    [self getNoteListAll:PAGE_NUM pageIndex:self.noteSearchPageIndex q:self.searchBar.text];
    //请求互动页
    [self.interPageList removeAllObjects];
    [self getInterPageListAll:PAGE_NUM pageIndex:self.interPageSearchPageIndex q:self.searchBar.text];
    
    //请求书籍
    [self.bookList removeAllObjects];
    [self getBookListAll:PAGE_NUM pageIndex:self.bookSearchPageIndex q:self.searchBar.text];
}

- (void)loadData{
    //请求笔记
    [self getNoteListAll:PAGE_NUM pageIndex:self.noteSearchPageIndex + 1 q:self.searchBar.text];
     //请求互动页
    [self getInterPageListAll:PAGE_NUM pageIndex:self.interPageSearchPageIndex + 1 q:self.searchBar.text];
    //请求书籍
    [self getBookListAll:PAGE_NUM pageIndex:self.bookSearchPageIndex + 1 q:self.searchBar.text];
}

//笔记 /api/note/getList
//互动页 /api/page/getList
//书籍 /api/book/getList

///获取笔记以及收藏列表,这个列表就是动态的列表
- (void)getNoteListAll:(NSInteger)pageNum pageIndex:(NSInteger)pageIndex q:(NSString *)q{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"limit":limit,@"page":page,@"q":q};
    [httpTools post:GET_NOTE_LIST_ALL andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"search note list:%@",dic);
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
            if ([item[@"book"] isKindOfClass:[NSDictionary class]]) {
                noteModel.book.book_id = item[@"book"][@"id"];
            }
            noteModel.user.user_id = item[@"user"][@"id"];
            [self.noteList addObject:noteModel];
        }
        self.noteSearchPageIndex = (self.noteList.count/PAGE_NUM) + (self.noteList.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}

- (void)getInterPageListAll:(NSInteger)pageNum  pageIndex:(NSInteger)pageIndex q:(NSString *)q{
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
            [self.interPageList addObject:pageListmodel];
        }
        self.interPageSearchPageIndex = (self.interPageList.count/PAGE_NUM) + (self.interPageList.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)getBookListAll:(NSInteger)pageNum pageIndex:(NSInteger)pageIndex q:(NSString *)q{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"limit":limit,@"page":page,@"q":q};
    [httpTools post:GET_BOOK_CLUB_LIST_ALL andParameters:param success:^(NSDictionary *dic) {
        NSLog(@"bookClub:%@",dic);
        NSArray * list = dic[@"data"][@"list"];
        for (NSDictionary * item in list) {
            SR_BookClubBookModel * model = [SR_BookClubBookModel modelWithDictionary:item];
            model.book_id = item[@"id"];
            [self.bookList addObject:model];
        }
        self.bookSearchPageIndex = (self.bookList.count/PAGE_NUM) + (self.bookList.count%PAGE_NUM > 0 ? 1 : 0);
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
        NSArray * titles = @[@"笔记",@"互动页",@"书籍"];
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
        self.hidesBottomBarWhenPushed = YES;
        SR_FoundSearchNoteViewController * searchVC = [[SR_FoundSearchNoteViewController alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
    }else if (icon.tag == 1){
        searchTag = SEARCH_TYPE_INTER_PAGE;
        self.hidesBottomBarWhenPushed = YES;
        SR_FoundSearchInterPageViewController * searchVC = [[SR_FoundSearchInterPageViewController alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
    }else{
        searchTag = SEARCH_TYPE_SCAN;
        self.hidesBottomBarWhenPushed = YES;
        SR_FoundSearchBookViewController * searchVC = [[SR_FoundSearchBookViewController alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}

- (NSMutableArray *)noteList{
    if (!_noteList) {
        _noteList = [[NSMutableArray alloc] init];
    }
    return _noteList;
}

- (NSMutableArray *)interPageList{
    if (!_interPageList) {
        _interPageList = [[NSMutableArray alloc] init];
    }
    return _interPageList;
}

- (NSMutableArray *)bookList{
    if (!_bookList) {
        _bookList = [[NSMutableArray alloc] init];
    }
    return _bookList;
}

@end
