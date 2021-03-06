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
#import "httpTools.h"
#import "UserInfo.h"
#import "SR_BookClubBookNoteModel.h"
#import "AVRefreshExtension.h"
#import "SR_FoundMainImageViewCell.h"
#import "SR_FoundMainVoiceViewCell.h"
#import "SR_FoundMainCollectionViewCell.h"
#import "SR_NoteDetailPageViewController.h"
#import "SR_MineViewController.h"
#import "SR_OthersMineViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MJRefresh.h>
#import "SR_InterPageListModel.h"
#import "SR_InterPageDetailViewController.h"
#import "NSDate+JJ.h"
#import "SR_ScanListItmeModel.h"
#import "SR_FoundMainBookClubBookNoteListViewController.h"
#import "SR_ScanNetPageViewController.h"

@interface SR_RecorMainViewController ()
@property(nonatomic,assign)NSInteger selectedTagIndex;
@property(nonatomic,strong)NSMutableArray * noteList;
@property(nonatomic,strong)NSMutableArray * collectionList;
@property(nonatomic,strong)NSMutableArray * scanList;
@property(nonatomic,assign)NSInteger collectionPageIndex;
@property(nonatomic,assign)NSInteger notePageIndex;
@property(nonatomic,assign)NSInteger scanPageIndex;
@property(nonatomic,strong)AVPlayer * remotePlayer;
@property(nonatomic,assign)NSInteger lastTag;
@property(nonatomic,assign)BOOL isFinishedPlay;
@property(nonatomic,strong)AVPlayerItem * playerItem;

@end

@implementation SR_RecorMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"记录";
    self.selectedTagIndex = 0;
    self.tableView.av_footer = [AVFooterRefresh footerRefreshWithScrollView:self.tableView footerRefreshingBlock:^{
        [self loadData];
    }];
    [self addHeaderRefresh];
}

- (void)addHeaderRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

- (void)loadNewData
{
    [self.noteList removeAllObjects];
    [self.collectionList removeAllObjects];
    [self.scanList removeAllObjects];
    
    self.collectionPageIndex = 0;
    self.notePageIndex = 0;
    self.scanPageIndex = 0;
    [self getListAll:PAGE_NUM pageIndex:self.notePageIndex mode:NOTE_MODE_NOTE];//暂时只获取笔记列表
//    [self getListAll:PAGE_NUM pageIndex:self.scanPageIndex mode:NOTE_MODE_SCAN];//暂时只获取扫描列表
    [self getListAll:PAGE_NUM pageIndex:self.collectionPageIndex mode:NOTE_MODE_COLLECTION];//暂时只获取收藏列表
    [self getScanPageList:PAGE_NUM pageIndex:self.scanPageIndex];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectedTagIndex == 0) {
        return self.noteList.count;
    }else if (self.selectedTagIndex == 1){
        return self.scanList.count;
    }else{
        return self.collectionList.count;
    }
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
        SR_BookClubBookNoteModel * noteModel = self.noteList[indexPath.row];
        if ([noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {
            return 146;
        }else if ([noteModel.type isEqualToString:NOTE_TYPE_PIX]){
            return 180;
        }else if ([noteModel.type isEqualToString:NOTE_TYPE_VOICE]){
            return 150;
        }else{
            return 106;
        }
    }else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedTagIndex == 0) {
        //根据type 来区分笔记的类型
        //        1文字
        //        2图片
        //        3语音

        SR_BookClubBookNoteModel * noteModel = self.noteList[indexPath.row];
        if ([noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {//文字信息
            NSString * cellId = @"SR_FoundMainTextViewCell";
            SR_FoundMainTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            cell.noteModel = self.noteList[indexPath.row];;
            __weak typeof(self) weakSelf = self;
            [cell addBlock:^{
                if ([noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {//自己的笔记跳转到自己的个人信息
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                    [weakSelf.navigationController pushViewController:mineVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }else{
                    SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                    otherVC.userModel = noteModel.user;
                    [weakSelf.navigationController pushViewController:otherVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }
            }];
            [cell addInterBlock:^{
                SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                if (noteModel.page) {//跳转到互动页
                    SR_InterPageListModel * interPageModel = [[SR_InterPageListModel alloc] init];
                    interPageModel.content = @"";
                    interPageModel.pageId = noteModel.page.page_id;
                    interPageModel.member_total = noteModel.member_total;
                    interPageModel.note_total = noteModel.note_total;
                    interPageModel.picture = @"";
                    interPageModel.time_create = noteModel.time_create;
                    interPageModel.time_create = noteModel.time_create;
                    SR_InterPageDetailViewController * interPageDetailVC = [[SR_InterPageDetailViewController alloc] init];
                    interPageDetailVC.pageListModel = interPageModel;
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:interPageDetailVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }else{//跳转到书籍对应的笔记列表
                    SR_FoundMainBookClubBookNoteListViewController * bookMarkListVC = [[SR_FoundMainBookClubBookNoteListViewController alloc] init];
                    SR_BookClubBookModel * bookModel = [[SR_BookClubBookModel alloc] init];
                    bookModel.book_id = noteModel.book.book_id;
                    bookModel.title = noteModel.book.title;
                    bookMarkListVC.bookModel = bookModel;
                    [weakSelf.navigationController pushViewController:bookMarkListVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
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
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                    [weakSelf.navigationController pushViewController:mineVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }else{
                    SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                    otherVC.userModel = noteModel.user;
                    [weakSelf.navigationController pushViewController:otherVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }
            }];
            [cell addInterBlock:^{
                SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                if (noteModel.page) {//跳转到互动页
                    SR_InterPageListModel * interPageModel = [[SR_InterPageListModel alloc] init];
                    interPageModel.content = @"";
                    interPageModel.pageId = noteModel.page.page_id;
                    interPageModel.member_total = noteModel.member_total;
                    interPageModel.note_total = noteModel.note_total;
                    interPageModel.picture = @"";
                    interPageModel.time_create = noteModel.time_create;
                    interPageModel.time_create = noteModel.time_create;
                    SR_InterPageDetailViewController * interPageDetailVC = [[SR_InterPageDetailViewController alloc] init];
                    interPageDetailVC.pageListModel = interPageModel;
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:interPageDetailVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }else{//跳转到书籍对应的笔记列表
                    SR_FoundMainBookClubBookNoteListViewController * bookMarkListVC = [[SR_FoundMainBookClubBookNoteListViewController alloc] init];
                    SR_BookClubBookModel * bookModel = [[SR_BookClubBookModel alloc] init];
                    bookModel.book_id = noteModel.book.book_id;
                    bookModel.title = noteModel.book.title;
                    bookMarkListVC.bookModel = bookModel;
                    [weakSelf.navigationController pushViewController:bookMarkListVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
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
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                    [weakSelf.navigationController pushViewController:mineVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }else{
                    SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                    otherVC.userModel = noteModel.user;
                    [weakSelf.navigationController pushViewController:otherVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }
            }];
            [cell addInterBlock:^{
                SR_InterPageViewController * interPaageVC = [[SR_InterPageViewController alloc] init];
                [weakSelf.navigationController pushViewController:interPaageVC animated:YES];
            }];
            
            [cell addVoiceBtnBlock:^(NSString *voiceUrl,float voiceTimeLength) {
                [weakSelf playVoiceWithFilePath:voiceUrl row:indexPath.row voiceTimeLength:voiceTimeLength];
            }];
            
            [cell addInterBlock:^{
                SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                if (noteModel.page) {//跳转到互动页
                    SR_InterPageListModel * interPageModel = [[SR_InterPageListModel alloc] init];
                    interPageModel.content = @"";
                    interPageModel.pageId = noteModel.page.page_id;
                    interPageModel.member_total = noteModel.member_total;
                    interPageModel.note_total = noteModel.note_total;
                    interPageModel.picture = @"";
                    interPageModel.time_create = noteModel.time_create;
                    interPageModel.time_create = noteModel.time_create;
                    SR_InterPageDetailViewController * interPageDetailVC = [[SR_InterPageDetailViewController alloc] init];
                    interPageDetailVC.pageListModel = interPageModel;
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:interPageDetailVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }else{//跳转到书籍对应的笔记列表
                    SR_FoundMainBookClubBookNoteListViewController * bookMarkListVC = [[SR_FoundMainBookClubBookNoteListViewController alloc] init];
                    SR_BookClubBookModel * bookModel = [[SR_BookClubBookModel alloc] init];
                    bookModel.book_id = noteModel.book.book_id;
                    bookModel.title = noteModel.book.title;
                    bookMarkListVC.bookModel = bookModel;
                    [weakSelf.navigationController pushViewController:bookMarkListVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }
            }];
            return cell;
        }else{
            NSString * cellId = @"SR_FoundMainTextViewCell";
            SR_FoundMainTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            cell.noteModel = self.noteList[indexPath.row];;
            __weak typeof(self) weakSelf = self;
            [cell addBlock:^{
                if ([noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {//自己的笔记跳转到自己的个人信息
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                    [weakSelf.navigationController pushViewController:mineVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }else{
                    SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                    otherVC.userModel = noteModel.user;
                    [weakSelf.navigationController pushViewController:otherVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }
            }];
            [cell addInterBlock:^{
                SR_BookClubBookNoteModel * noteModel = weakSelf.noteList[indexPath.row];
                if (noteModel.page) {//跳转到互动页
                    SR_InterPageListModel * interPageModel = [[SR_InterPageListModel alloc] init];
                    interPageModel.content = @"";
                    interPageModel.pageId = noteModel.page.page_id;
                    interPageModel.member_total = noteModel.member_total;
                    interPageModel.note_total = noteModel.note_total;
                    interPageModel.picture = @"";
                    interPageModel.time_create = noteModel.time_create;
                    interPageModel.time_create = noteModel.time_create;
                    SR_InterPageDetailViewController * interPageDetailVC = [[SR_InterPageDetailViewController alloc] init];
                    interPageDetailVC.pageListModel = interPageModel;
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:interPageDetailVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }else{//跳转到书籍对应的笔记列表
                    SR_FoundMainBookClubBookNoteListViewController * bookMarkListVC = [[SR_FoundMainBookClubBookNoteListViewController alloc] init];
                    SR_BookClubBookModel * bookModel = [[SR_BookClubBookModel alloc] init];
                    bookModel.book_id = noteModel.book.book_id;
                    bookModel.title = noteModel.book.title;
                    bookMarkListVC.bookModel = bookModel;
                    [weakSelf.navigationController pushViewController:bookMarkListVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }
            }];
            return cell;
        }
    }
//    else if (self.selectedTagIndex == 2){//收藏列表
//        SR_BookClubBookNoteModel * noteModel = self.collectionList[indexPath.row];
//        NSString * cellId = @"SR_FoundMainCollectionViewCell";
//        SR_FoundMainCollectionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        if (!cell) {
//            cell = [[SR_FoundMainCollectionViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
//        }
//        cell.noteModel = self.collectionList[indexPath.row];
//        __weak typeof(self) weakSelf = self;
//        [cell addBlock:^{
//            if ([noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {//自己的笔记跳转到自己的个人信息
//                weakSelf.hidesBottomBarWhenPushed = YES;
//                SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
//                [weakSelf.navigationController pushViewController:mineVC animated:YES];
//                weakSelf.hidesBottomBarWhenPushed = NO;
//            }else{
//                SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
//                weakSelf.hidesBottomBarWhenPushed = YES;
//                SR_BookClubBookNoteModel * noteModel = weakSelf.collectionList[indexPath.row];
//                otherVC.userModel = noteModel.user;
//                [weakSelf.navigationController pushViewController:otherVC animated:YES];
//                weakSelf.hidesBottomBarWhenPushed = NO;
//            }
//        }];
//        [cell addInterBlock:^{
//            SR_BookClubBookNoteModel * noteModel = weakSelf.collectionList[indexPath.row];
//            SR_InterPageListModel * interPageModel = [[SR_InterPageListModel alloc] init];
//            interPageModel.content = @"";
//            interPageModel.pageId = noteModel.page.page_id;
//            interPageModel.member_total = noteModel.member_total;
//            interPageModel.note_total = noteModel.note_total;
//            interPageModel.picture = @"";
//            interPageModel.time_create = noteModel.time_create;
//            interPageModel.time_create = noteModel.time_create;
//            SR_InterPageDetailViewController * interPageDetailVC = [[SR_InterPageDetailViewController alloc] init];
//            interPageDetailVC.pageListModel = interPageModel;
//            weakSelf.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:interPageDetailVC animated:YES];
//            weakSelf.hidesBottomBarWhenPushed = NO;
//        }];
//        
//        return cell;
//    }
    else{//扫描列表
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
            SR_BookClubBookNoteModel * noteModel = self.scanList[indexPath.row];
            NSDate * createData = [NSDate dateWithTimeIntervalSince1970:noteModel.time_create];
            NSString * time = [NSDate compareCurrentTime:createData];
            cell.textLabel.text = time;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"扫描了 %@",noteModel.title];
        }else{//收藏
            SR_BookClubBookNoteModel * noteModel = self.collectionList[indexPath.row];
            NSDate * createData = [NSDate dateWithTimeIntervalSince1970:noteModel.time_create];
            NSString * time = [NSDate compareCurrentTime:createData];//[NSDate getRealDateTime:createData withFormat:@"yyyy-MM-dd HH:mm"];
        
            cell.textLabel.text = time;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"收藏了 %@",noteModel.title];
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
        SR_BookClubBookNoteModel * noteModel = self.noteList[indexPath.row];
        SR_NoteDetailPageViewController * noteDetailVC = [[SR_NoteDetailPageViewController alloc] init];
        noteDetailVC.noteModel = noteModel;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noteDetailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if (self.selectedTagIndex == 2){//扫描、收藏
        SR_BookClubBookNoteModel * noteModel = self.collectionList[indexPath.row];
        noteModel.type = NOTE_TYPE_COLLECTION;
        SR_NoteDetailPageViewController * noteDetailVC = [[SR_NoteDetailPageViewController alloc] init];
        noteDetailVC.noteModel = noteModel;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noteDetailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        SR_ScanListItmeModel * itemModel = self.scanList[indexPath.row];
        if (itemModel.target_type || itemModel.target_id){
            if ([itemModel.target_type isEqualToString:@"book"]) {//跳转到书本
                SR_FoundMainBookClubBookNoteListViewController * bookMarkListVC = [[SR_FoundMainBookClubBookNoteListViewController alloc] init];
                SR_BookClubBookModel * bookModel = [[SR_BookClubBookModel alloc] init];
                bookModel.book_id = itemModel.target_id;
                bookMarkListVC.bookModel = bookModel;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:bookMarkListVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }else if ([itemModel.target_type isEqualToString:@"page"]) {//跳转到互动页
                SR_InterPageDetailViewController * pageDetailVC = [[SR_InterPageDetailViewController alloc] init];
                SR_InterPageListModel * pageListModel = [[SR_InterPageListModel alloc] init];
                pageListModel.pageId = itemModel.target_id;
                pageDetailVC.pageListModel = pageListModel;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pageDetailVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }else if ([itemModel.target_type isEqualToString:@"user"]) {//跳转到用户
                if ([itemModel.target_id isEqualToString:[UserInfo getUserId]]) {
                    SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:mineVC animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }else{
                    SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                    SR_BookClubNoteUserModel * userModel = [[SR_BookClubNoteUserModel alloc] init];
                    userModel.user_id = itemModel.target_id;
                    otherVC.userModel = userModel;
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:otherVC animated:YES];
                    self.hidesBottomBarWhenPushed = NO;
                }
            }else{
                self.hidesBottomBarWhenPushed = YES;
                SR_ScanNetPageViewController * netPageVC = [[SR_ScanNetPageViewController alloc] init];
                netPageVC.url = itemModel.url;
                [self.navigationController pushViewController:netPageVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
        }
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
- (void)clickHeaderBtn:(UIButton *)btn{
    self.selectedTagIndex = btn.tag;
    [self.tableView reloadData];
}

- (void)getListAll:(NSInteger)pageNum pageIndex:(NSInteger)pageIndex mode:(NSString *)mode{
    NSString * userId = [UserInfo getUserId];
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"user_id":userId,@"limit":limit,@"page":page,@"mode":mode};
    [httpTools post:GET_NOTE_LIST_ALL andParameters:param success:^(NSDictionary *dic) {
        
        NSArray * list = dic[@"data"][@"list"];
        for (NSDictionary * item in list) {
            SR_BookClubBookNoteModel * noteModel = [SR_BookClubBookNoteModel modelWithDictionary:item];
            noteModel.note_id = item[@"id"];
            if ([item[@"book"] isKindOfClass:[NSDictionary class]]) {
                noteModel.book.book_id = item[@"book"][@"id"];
            }
            if ([item[@"page"] isKindOfClass:[NSDictionary class]]) {
                noteModel.page.page_id = item[@"page"][@"id"];
            }
            noteModel.user.user_id = item[@"user"][@"id"];
            if ([mode isEqualToString:NOTE_MODE_COLLECTION]) {//请求收藏列表
                [self.collectionList addObject:noteModel];
                
            }else if ([mode isEqualToString:NOTE_MODE_NOTE]){//请求笔记列表
                [self.noteList addObject:noteModel];
                
            }
        }
        
        if ([mode isEqualToString:NOTE_MODE_COLLECTION]) {//请求收藏列表
            self.collectionPageIndex = (self.collectionList.count/PAGE_NUM) + (self.collectionList.count%PAGE_NUM > 0 ? 1 : 0);
        }else if ([mode isEqualToString:NOTE_MODE_NOTE]){//请求笔记列表
            self.notePageIndex = (self.noteList.count/PAGE_NUM) + (self.noteList.count%PAGE_NUM > 0 ? 1 : 0);
        }else if ([mode isEqualToString:NOTE_MODE_SCAN]){//请求扫描列表
            
        }
        
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        //区分不同类型的笔记进行不同model的转换
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}

- (void)getScanPageList:(NSInteger)pageNum pageIndex:(NSInteger)pageIndex{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken,@"limit":limit,@"page":page};
    //SR_ScanListItmeModel
    [httpTools post:GET_SCAN_PAGE_LIST andParameters:param success:^(NSDictionary *dic) {
        NSLog(@"scan:%@",dic);
        NSArray * list = dic[@"data"][@"list"];
        for (NSDictionary * dic in list) {
            SR_ScanListItmeModel * itemModel = [SR_ScanListItmeModel modelWithDictionary:dic];
            itemModel.modelId = dic[@"id"];
            [self.scanList addObject:itemModel];
        }
        self.scanPageIndex = (self.scanList.count/PAGE_NUM) + (self.scanList.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadData{
    if (self.selectedTagIndex == 0) {
        [self getListAll:PAGE_NUM pageIndex:self.notePageIndex mode:NOTE_MODE_NOTE];
    }else if (self.selectedTagIndex == 1){
        [self getListAll:PAGE_NUM pageIndex:self.collectionPageIndex mode:NOTE_MODE_COLLECTION];
    }else{
        [self getScanPageList:PAGE_NUM pageIndex:self.scanPageIndex];
    }
}

- (NSMutableArray *)noteList{
    if (!_noteList) {
        _noteList = [[NSMutableArray alloc] init];
    }
    return _noteList;
}

- (NSMutableArray *)collectionList{
    if (!_collectionList) {
        _collectionList = [[NSMutableArray alloc] init];
    }
    return _collectionList;
}

- (NSMutableArray *)scanList{
    if (!_scanList) {
        _scanList = [[NSMutableArray alloc] init];
    }
    return _scanList;
}


@end
