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
#import "SR_FoundMainCollectionViewCell.h"
#import "SR_MineViewController.h"
#import "SR_FoundSearchTableViewController.h"
#import "SR_FoundMainTextViewCell.h"
#import "SR_FoundMainTextSelfViewCell.h"
#import "SR_FoundMainImageSelfViewCell.h"
#import "SR_FoundMainVoiceSelfViewCell.h"
#import "SR_FoundMainTextSelfViewCell.h"
#import "globalHeader.h"
#import "SR_FoundMainDynamicViewCell.h"
#import "SR_FoundMainBookClubBookNoteListViewController.h"
#import "SR_InterPageViewController.h"

#import "SR_ActionSheetVoiceView.h"
#import "httpTools.h"
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>
#import "UserInfo.h"
#import "SR_BookClubBookModel.h"
#import "SR_ActionSheetImageView.h"
#import "SR_ActionSheetTextView.h"
#import "SR_BookClubBookNoteModel.h"
#import "VoiceViewController.h"
#import "AVRefreshExtension.h"

#import "SR_NoteDetailPageViewController.h"
#import "SR_OthersMineViewController.h"

#import <MJRefresh.h>
#import "SR_InterPageListModel.h"
#import "SR_InterPageDetailViewController.h"
#import "SR_LogMessageModel.h"
#import "SR_ScanNetPageViewController.h"
#import <YYKit/YYKit.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "WeiboSDK.h"
#import "SR_ShareView.h"

#import "ShareTool.h"

@interface SR_FoundMainViewController ()<addBtnDelegate,UIAlertViewDelegate,textViewSendBtnDelegate,imageViewSendBtnDelegate,voiceViewSendBtnDelegate>
@property(nonatomic,assign)BOOL isSelectBookClub;
@property(nonatomic,strong)NSMutableArray * bookClubs;
@property(nonatomic,strong)NSMutableArray * dynamicInfos;
@property(nonatomic,assign)NSInteger bookClubPageIndex;
@property(nonatomic,assign)NSInteger dynamicInfoPageIndex;
@property(nonatomic,strong)UIButton * floatBtn;
@property(nonatomic,strong)AVPlayer * remotePlayer;
@property(nonatomic,assign)NSInteger lastTag;
@property(nonatomic,assign)BOOL isFinishedPlay;
@property(nonatomic,strong)AVPlayerItem * playerItem;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)NSMutableArray * logMessages;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)NSInteger scrollViewCurrentPage;
@end

@implementation SR_FoundMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"发现";
    
    UIBarButtonItem * mineItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fx_twoman"] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickMineItem)];
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fx_ss"] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickSearchItem)];
    self.navigationItem.rightBarButtonItems = @[mineItem,searchItem];
    
    [self.view addSubview:self.floatBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanHasBook:) name:SR_NOTI_SCAN_HAS_BOOK object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createNewBook:) name:SR_NOTI_CREATE_BOOK object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createNewPageNote:) name:SR_NOTI_CREATE_PAGE_NOTE object:nil];
 
    self.tableView.av_footer = [AVFooterRefresh footerRefreshWithScrollView:self.tableView footerRefreshingBlock:^{
        [self loadData];
    }];
    [self addHeaderRefresh];
    [self checkTokenTimeout];
    [self addTimer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)clickSearchItem{
    self.hidesBottomBarWhenPushed = YES;
    SR_FoundSearchTableViewController * foundVC = [[SR_FoundSearchTableViewController alloc] init];
    [self.navigationController pushViewController:foundVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKEnableUseClientShare]; //打开客户端分享
//    [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                     images:[UIImage imageNamed:@"传入的图片名"]
//                                        url:[NSURL URLWithString:@"http://mob.com"]
//                                      title:@"分享标题"
//                                       type:SSDKContentTypeAuto];
    
    // 定制新浪微博的分享内容
//    [shareParams SSDKSetupSinaWeiboShareParamsByText:@"定制新浪微博的分享内容" title:nil image:[UIImage imageNamed:@"传入的图片名"] url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    // 定制微信好友的分享内容
//    [shareParams SSDKSetupWeChatParamsByText:@"定制微信的分享内容" title:@"title" url:[NSURL URLWithString:@"http://mob.com"] thumbImage:nil image:[UIImage imageNamed:@"传入的图片名"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
    
    //2、分享
//    [ShareSDK share:(SSDKPlatformTypeSinaWeibo) parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//        NSLog(@"state:%d",state);
//        
//    }];

}

- (void)clickMineItem{
    self.hidesBottomBarWhenPushed = YES;
    SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
    [self.navigationController pushViewController:mineVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.isSelectBookClub == YES ? self.bookClubs.count : self.dynamicInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.logMessages.count) {
            return 80;
        }else{
            return 42;
        }
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSelectBookClub) {
        return 128;
    }else{
        SR_BookClubBookNoteModel * noteModel = self.dynamicInfos[indexPath.row];
        if ([noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {
            return 146;
        }else if ([noteModel.type isEqualToString:NOTE_TYPE_PIX]){
            return 180;
        }else if ([noteModel.type isEqualToString:NOTE_TYPE_VOICE]){
            return 150;
        }else{
            return 106;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSelectBookClub) {
        NSString * cellId = @"SR_FoundMainDynamicViewCell";
        SR_FoundMainDynamicViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_FoundMainDynamicViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.bookModel = self.bookClubs[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        //根据type 来区分笔记的类型
        //        1文字
        //        2图片
        //        3语音
        //        4收藏
        SR_BookClubBookNoteModel * noteModel = self.dynamicInfos[indexPath.row];
        if ([noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {//文字信息
            NSString * cellId = @"SR_FoundMainTextViewCell";
            SR_FoundMainTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            cell.noteModel = self.dynamicInfos[indexPath.row];
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
                    SR_BookClubBookNoteModel * noteModel = weakSelf.dynamicInfos[indexPath.row];
                    otherVC.userModel = noteModel.user;
                    [weakSelf.navigationController pushViewController:otherVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }
            }];
            [cell addInterBlock:^{
                SR_BookClubBookNoteModel * noteModel = weakSelf.dynamicInfos[indexPath.row];
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
            }];
            return cell;
        }else if ([noteModel.type isEqualToString:NOTE_TYPE_PIX]){//图片
            NSString * cellId = @"SR_FoundMainImageViewCell";
            SR_FoundMainImageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainImageViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            cell.noteModel = self.dynamicInfos[indexPath.row];
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
                    SR_BookClubBookNoteModel * noteModel = weakSelf.dynamicInfos[indexPath.row];
                    otherVC.userModel = noteModel.user;
                    [weakSelf.navigationController pushViewController:otherVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }
            }];
            [cell addInterBlock:^{
                SR_BookClubBookNoteModel * noteModel = weakSelf.dynamicInfos[indexPath.row];
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
            }];
            return cell;

        }else if ([noteModel.type isEqualToString:NOTE_TYPE_VOICE]){//语音
            NSString * cellId = @"SR_FoundMainVoiceViewCell";
            SR_FoundMainVoiceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainVoiceViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            cell.noteModel = self.dynamicInfos[indexPath.row];
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
                    SR_BookClubBookNoteModel * noteModel = weakSelf.dynamicInfos[indexPath.row];
                    otherVC.userModel = noteModel.user;
                    [weakSelf.navigationController pushViewController:otherVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }
            }];
            [cell addInterBlock:^{
                SR_BookClubBookNoteModel * noteModel = weakSelf.dynamicInfos[indexPath.row];
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
            cell.noteModel = self.dynamicInfos[indexPath.row];
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
                    SR_BookClubBookNoteModel * noteModel = weakSelf.dynamicInfos[indexPath.row];
                    otherVC.userModel = noteModel.user;
                    [weakSelf.navigationController pushViewController:otherVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }
            }];
            [cell addInterBlock:^{
                SR_BookClubBookNoteModel * noteModel = weakSelf.dynamicInfos[indexPath.row];
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
            }];
           
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSelectBookClub) {//读书会->笔记列表
        self.hidesBottomBarWhenPushed = YES;
        SR_FoundMainBookClubBookNoteListViewController * bookMarkListVC = [[SR_FoundMainBookClubBookNoteListViewController alloc] init];
        bookMarkListVC.bookModel = self.bookClubs[indexPath.row];
        [self.navigationController pushViewController:bookMarkListVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{//动态->笔记详情页
        SR_BookClubBookNoteModel * noteModel = self.dynamicInfos[indexPath.row];
        SR_NoteDetailPageViewController * noteDetailVC = [[SR_NoteDetailPageViewController alloc] init];
        noteDetailVC.noteModel = noteModel;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noteDetailVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        CGFloat heightForScrollView = 38;
        if (!self.logMessages.count) {
            heightForScrollView = 0;
        }
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 42 + heightForScrollView)];//42 - 80
        headerView.backgroundColor = [UIColor whiteColor];
        
        //添加轮播图
        
        if (self.logMessages.count) {
            UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 36)];
            scrollView.backgroundColor = [UIColor whiteColor];
            scrollView.pagingEnabled = YES;
            scrollView.userInteractionEnabled = YES;
            scrollView.showsVerticalScrollIndicator = YES;
            scrollView.shouldGroupAccessibilityChildren = YES;
            scrollView.delegate = self;
            self.scrollView = scrollView;
            
            [headerView addSubview:scrollView];
            scrollView.contentSize = CGSizeMake(kScreenWidth * self.logMessages.count, 36);
            for (int i = 0 ; i < self.logMessages.count; i ++) {
                
                UIView * headerNotiBgView = [[UIView alloc] initWithFrame:CGRectMake(i*(kScreenWidth), 0, kScreenWidth, 36)];
                headerView.backgroundColor = kColor(0xe2, 0xea, 0xe8);
                headerNotiBgView.tag = 100 + i;
                
                UITapGestureRecognizer * headerNotiBgViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScrollviewTitle:)];
                [headerNotiBgView addGestureRecognizer:headerNotiBgViewTap];
                
                [scrollView addSubview:headerNotiBgView];
                
                SR_LogMessageModel * logMessageModel = self.logMessages[i];
                
                YYAnimatedImageView * headerImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(15, 3, 30, 30)];
                headerImageView.layer.cornerRadius = 15;
                headerImageView.layer.masksToBounds = YES;
                [headerImageView setImageWithURL:[NSURL URLWithString:logMessageModel.avatar] placeholder:[UIImage imageNamed:@"headerIcon"]];
                [headerNotiBgView addSubview:headerImageView];
                
                UILabel * notiLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImageView.frame.origin.x + headerImageView.frame.size.width + 10, 0, kScreenWidth - 30 - 10 - headerImageView.frame.size.width, 36)];
                notiLabel.text = [NSString stringWithFormat:@"%@  %@",logMessageModel.username,logMessageModel.content];
                notiLabel.textColor = baseblackColor;
                notiLabel.font = [UIFont systemFontOfSize:13.0];
                notiLabel.textAlignment = NSTextAlignmentLeft;
                [headerNotiBgView addSubview:notiLabel];
            }
        }else{
            
        }
        
        NSArray * titles = @[@"动态",@"读书会"];
        for (int i = 0; i < 2; i ++) {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i*(kScreenWidth/2), 1 + heightForScrollView, kScreenWidth/2, 42)];
            [btn setTitle:titles[i] forState:(UIControlStateNormal)];
            [btn setTitleColor:baseColor forState:(UIControlStateNormal)];
            [btn setTitle:titles[i] forState:(UIControlStateSelected)];
            [btn setTitleColor:kColor(0x88, 0x88, 0x88) forState:(UIControlStateSelected)];
            btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
            if (i == 0) {
                [btn setSelected:self.isSelectBookClub];
                
            }else{
                [btn setSelected:!self.isSelectBookClub];
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(clickHeaderBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [headerView addSubview:btn];
        }
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2,  heightForScrollView + 1 , 0.5, 40)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:lineView];

//        UIView * notiLabelBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, notiLabel.frame.origin.y + notiLabel.frame.size.height, kScreenWidth, 0.5)];
//        notiLabelBottomLineView.backgroundColor = [UIColor lightGrayColor];
//        [headerView addSubview:notiLabelBottomLineView];
        
        return headerView;
    }else{
        return nil;
    }
}

- (void)scanHasBook:(NSNotification *)noti{
    NSString * value = noti.userInfo[SR_NOTI_SCAN_HAS_BOOK_KEY_1];
    if ([value isEqualToString:SR_NOTI_SCAN_HAS_BOOK_KEY_1]) {
        self.isSelectBookClub = YES;
        self.lastTag = 1;
        [self.tableView reloadData];
    }
}

- (void)createNewBook:(NSNotification *)noti{
    NSString * value = noti.userInfo[SR_NOTI_CREATE_BOOK_KEY_1];
    if ([value isEqualToString:SR_NOTI_CREATE_BOOK_KEY_1]) {
        [self.bookClubs removeAllObjects];
        self.bookClubPageIndex = 0;
        [self getBookClubList:PAGE_NUM pageIndex:self.bookClubPageIndex];
    }
}

- (void)createNewPageNote:(NSNotification *)noti{
    NSString * value = noti.userInfo[SR_NOTI_CREATE_PAGE_NOTE_KEY_1];
    if ([value isEqualToString:SR_NOTI_CREATE_PAGE_NOTE_KEY_1]) {
        [self.dynamicInfos removeAllObjects];
        self.dynamicInfoPageIndex = 0;
        [self getListAll:PAGE_NUM pageIndex:self.dynamicInfoPageIndex];
    }
}

- (void)addHeaderRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

- (void)loadNewData{
    [self.dynamicInfos removeAllObjects];
    [self.bookClubs removeAllObjects];
    self.dynamicInfoPageIndex = 0;
    self.bookClubPageIndex = 0;
    [self getListAll:PAGE_NUM pageIndex:self.dynamicInfoPageIndex];
    [self getBookClubList:PAGE_NUM pageIndex:self.bookClubPageIndex];
    [self getLogMessageList:PAGE_NUM pageIndex:0];
}

- (void)clickScrollviewTitle:(UIGestureRecognizer *)gesture{
    NSInteger index = gesture.view.tag - 100;
    SR_LogMessageModel * logMessageModel = self.logMessages[index];
    if (logMessageModel.target_type || logMessageModel.target_id){
        if ([logMessageModel.target_type isEqualToString:@"book"]) {//跳转到书本
            SR_FoundMainBookClubBookNoteListViewController * bookMarkListVC = [[SR_FoundMainBookClubBookNoteListViewController alloc] init];
            SR_BookClubBookModel * bookModel = [[SR_BookClubBookModel alloc] init];
            bookModel.book_id = logMessageModel.target_id;
            bookMarkListVC.bookModel = bookModel;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bookMarkListVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if ([logMessageModel.target_type isEqualToString:@"page"]) {//跳转到互动页
            SR_InterPageDetailViewController * pageDetailVC = [[SR_InterPageDetailViewController alloc] init];
            SR_InterPageListModel * pageListModel = [[SR_InterPageListModel alloc] init];
            pageListModel.pageId = logMessageModel.target_id;
            pageDetailVC.pageListModel = pageListModel;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pageDetailVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if ([logMessageModel.target_type isEqualToString:@"user"]) {//跳转到用户
            if ([logMessageModel.target_id isEqualToString:[UserInfo getUserId]]) {
                SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:mineVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }else{
                SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
                SR_BookClubNoteUserModel * userModel = [[SR_BookClubNoteUserModel alloc] init];
                userModel.user_id = logMessageModel.target_id;
                otherVC.userModel = userModel;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:otherVC animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
    }else{
        self.hidesBottomBarWhenPushed = YES;
        SR_ScanNetPageViewController * netPageVC = [[SR_ScanNetPageViewController alloc] init];
        netPageVC.url = logMessageModel.url;
        [self.navigationController pushViewController:netPageVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
        
        }
    }

    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollView == scrollView) {
        CGFloat scrollviewW =  scrollView.frame.size.width;
        CGFloat x = scrollView.contentOffset.x;
        int page = (x + scrollviewW / 2) /  scrollviewW;
        self.scrollViewCurrentPage = page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

- (void)removeTimer{
    [self.timer invalidate];
}

- (void)nextImage{
    static BOOL scrollDirection = YES;
    int page = (int)self.scrollViewCurrentPage;
    if (page == self.logMessages.count -1) {
        page = 0;
        scrollDirection = NO;
        
    }else{
        if (scrollDirection == YES) {
            page++;
        }else{
            page --;
        }
    }
    if (page == 0){
        scrollDirection = YES;
        
    }
    if (page < 0) {
        page = 0;
    }
    if (page > self.logMessages.count -1) {
        page = (int)self.logMessages.count -1;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGFloat x = page * self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(x, 0);
    [UIView commitAnimations];
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
    if (self.lastTag != btn.tag) {
        self.isSelectBookClub = !self.isSelectBookClub;
        [self.tableView reloadData];
        self.lastTag = btn.tag;
    }
}

///创建笔记之前先判断账号是否已经超时
- (void)clickFloatBtn{
    NSString * userPhone = [UserInfo getUserPhoneNumber];
    NSString * userPwd = [UserInfo getUserPassword];
    NSDictionary * param = @{@"username":userPhone,@"password":userPwd};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:LOGIN andParameters:param success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        SSLog(@"relogin:%@",dic);
        if ([dic[@"status"] isEqualToString:@"1"]) {
            NSDictionary * userDic = dic[@"data"][@"user"];
            [UserInfo saveUserAvatarWith:userDic[@"avatar"]];
            [UserInfo saveUserIDWith:userDic[@"id"]];
            [UserInfo saveUserTokenWith:dic[@"data"][@"user_token"]];
            [UserInfo saveUserNameWith:userDic[@"username"]];
            [UserInfo saveUserLevelWith:userDic[@"level"]];
            [UserInfo saveUserPublicWith:userDic[@"public"]];
            [UserInfo saveUserCreditWith:userDic[@"credit"]];
            [UserInfo saveUserPhoneNumberWith:userPhone];
            [UserInfo saveUserPasswordWith:userPwd];
            
            SR_AddBtnView * addBtnView = [[SR_AddBtnView alloc] initAlertView];
            addBtnView.delegate = self;
            [addBtnView show];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)clickAddBtnView:(NSInteger)tag{
    if (tag == 2) {
        SR_ActionSheetTextView * textView = [[SR_ActionSheetTextView alloc] initActionSheetWith:nil text:nil];
        textView.delegate = self;
        textView.requestType = NOTE_REQUSERT_TYPE_SAVE;
        [textView show];
    }else if (tag == 3){
        SR_ActionSheetImageView * imageView = [[SR_ActionSheetImageView alloc] initActionSheetWith:nil images:nil viewController:self];
        imageView.delegate = self;
        imageView.viewController = self;
        imageView.requestType = NOTE_REQUSERT_TYPE_SAVE;
        [imageView show];
    }else if (tag == 4){
        SR_ActionSheetVoiceView * voiceView = [[SR_ActionSheetVoiceView alloc] initActionSheetWith:nil voices:nil viewController:self];
        voiceView.delegate = self;
        voiceView.requestType = NOTE_REQUSERT_TYPE_SAVE;
        [voiceView show];
    }
}

///做没有对象的笔记，已经刷新了数据，有可能后台没有更新那么快
- (void)clickTextViewSendBtn:(NSString *)title text:(NSString *)text{
    SSLog(@"title:%@ content:%@",title,text);
    [self.dynamicInfos removeAllObjects];
    self.dynamicInfoPageIndex = 0;
    [self.bookClubs removeAllObjects];
    self.bookClubPageIndex = 0;
    [self getListAll:PAGE_NUM pageIndex:self.dynamicInfoPageIndex];
    [self getBookClubList:PAGE_NUM pageIndex:self.bookClubPageIndex];
}

- (void)clickImageViewSendBtn:(NSString *)title images:(NSArray *)images{
    SSLog(@"image title:%@",title);
    [self.dynamicInfos removeAllObjects];
    self.dynamicInfoPageIndex = 0;
    [self.bookClubs removeAllObjects];
    self.bookClubPageIndex = 0;
    [self getListAll:PAGE_NUM pageIndex:self.dynamicInfoPageIndex];
    [self getBookClubList:PAGE_NUM pageIndex:self.bookClubPageIndex];
}

- (void)clickVoiceViewSendBtn:(NSString *)title text:(NSString *)text{
    SSLog(@"voice title:%@",title);
    [self.dynamicInfos removeAllObjects];
    self.dynamicInfoPageIndex = 0;
    [self.bookClubs removeAllObjects];
    self.bookClubPageIndex = 0;
    [self getListAll:PAGE_NUM pageIndex:self.dynamicInfoPageIndex];
    [self getBookClubList:PAGE_NUM pageIndex:self.bookClubPageIndex];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[SR_LoginViewController alloc] init];
}

- (void)loadData{
    if (self.isSelectBookClub) {
        //先判断是否已经请求到最后一了。
        if (self.bookClubs.count < PAGE_NUM*(self.bookClubPageIndex + 1)) {
            SSLog(@"已经是最后一条数据了");
            [self.tableView.av_footer endFooterRefreshing];
        }else{
            [self getBookClubList:PAGE_NUM pageIndex:self.bookClubPageIndex + 1];
        }
//        [self getBookClubList:PAGE_NUM pageIndex:self.bookClubPageIndex];
    }else{
        //先判断是否已经请求到最后一了。
        if (self.dynamicInfos.count < PAGE_NUM*(self.dynamicInfoPageIndex + 1)) {
            SSLog(@"已经是最后一条数据了");
            [self.tableView.av_footer endFooterRefreshing];
        }else{
            [self getListAll:PAGE_NUM pageIndex:self.dynamicInfoPageIndex + 1];
        }
//        [self getListAll:PAGE_NUM pageIndex:self.dynamicInfoPageIndex];
    }
}

///获取笔记以及收藏列表,这个列表就是动态的列表
- (void)getListAll:(NSInteger)pageNum pageIndex:(NSInteger)pageIndex{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSString * userId = [UserInfo getUserId];
    NSDictionary * param = @{@"limit":limit,@"page":page,@"mode":@"1"};
    [httpTools post:GET_NOTE_LIST_ALL andParameters:param success:^(NSDictionary *dic) {
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
            if ([item[@"book"] isKindOfClass:[NSDictionary class]]) {
                noteModel.book.book_id = item[@"book"][@"id"];
            }
            if ([item[@"page"] isKindOfClass:[NSDictionary class]]) {
                noteModel.page.page_id = item[@"page"][@"id"];
            }
            noteModel.user.user_id = item[@"user"][@"id"];
            [self.dynamicInfos addObject:noteModel];
        }
        self.dynamicInfoPageIndex = (self.dynamicInfos.count/PAGE_NUM) + (self.dynamicInfos.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}

///获取读书会书籍列表
- (void)getBookClubList:(NSInteger)pageNum  pageIndex:(NSInteger)pageIndex{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"limit":limit,@"page":page};
    [httpTools post:GET_BOOK_CLUB_LIST_ALL andParameters:param success:^(NSDictionary *dic) {
        NSLog(@"bookClub:%@",dic);
        NSArray * list = dic[@"data"][@"list"];
        for (NSDictionary * item in list) {
            SR_BookClubBookModel * model = [SR_BookClubBookModel modelWithDictionary:item];
            model.book_id = item[@"id"];
            [self.bookClubs addObject:model];
        }
        [self updateSR_BookClubBookModelToLocal:self.bookClubs];
        
        self.bookClubPageIndex = (self.bookClubs.count/PAGE_NUM) + (self.bookClubs.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}

///获取轮播图消息
- (void)getLogMessageList:(NSInteger)pageNum  pageIndex:(NSInteger)pageIndex{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"limit":limit,@"page":page};
    [httpTools post:LOG_MESSAGE_LIST andParameters:param success:^(NSDictionary *dic) {
        NSLog(@"log message:%@",dic);
        NSArray * list = dic[@"data"][@"list"];
        for (NSDictionary * item in list) {
            SR_LogMessageModel * model = [SR_LogMessageModel modelWithDictionary:item];
            model.logMessage_id = item[@"id"];
            [self.logMessages addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}

///查询当前账号是否在其他地方登录了。
- (void)checkTokenTimeout{
    NSString * userPhone = [UserInfo getUserPhoneNumber];
    NSString * userPwd = [UserInfo getUserPassword];
    NSDictionary * param = @{@"username":userPhone,@"password":userPwd};
    [httpTools post:LOGIN andParameters:param success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        SSLog(@"login:%@",dic);
        if ([dic[@"status"] isEqualToString:@"1"]) {
            NSDictionary * userDic = dic[@"data"][@"user"];
            [UserInfo saveUserAvatarWith:userDic[@"avatar"]];
            [UserInfo saveUserIDWith:userDic[@"id"]];
            [UserInfo saveUserTokenWith:dic[@"data"][@"user_token"]];
            [UserInfo saveUserNameWith:userDic[@"username"]];
            [UserInfo saveUserLevelWith:userDic[@"level"]];
            [UserInfo saveUserPublicWith:userDic[@"public"]];
            [UserInfo saveUserCreditWith:userDic[@"credit"]];
            [UserInfo saveUserPhoneNumberWith:userPhone];
            [UserInfo saveUserPasswordWith:userPwd];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)queryBookClubModelFromLocal{
    NSArray * models = [SR_BookClubBookModel queryModelWihtWhere:nil orderBy:nil count:0];
    [self.bookClubs addObjectsFromArray:models];
    [self.tableView reloadData];
}

- (void)updateSR_BookClubBookModelToLocal:(NSArray *)dataSource{
    [LKDBHelper clearTableData:[SR_BookClubBookModel class]];
    for (SR_BookClubBookModel * model in dataSource){
        [SR_BookClubBookModel insertModel:model];
    }
}

- (NSMutableArray *)bookClubs{
    if (!_bookClubs) {
        _bookClubs = [[NSMutableArray alloc] init];
    }
    return _bookClubs;
}

- (NSMutableArray *)dynamicInfos{
    if (!_dynamicInfos) {
        _dynamicInfos = [[NSMutableArray alloc] init];
    }
    return _dynamicInfos;
}

- (UIButton *)floatBtn{
    if (!_floatBtn) {
        _floatBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _floatBtn.frame = CGRectMake(0, 0, 65, 65);
        _floatBtn.center = CGPointMake(kScreenWidth - 5 - 33, kScreenHeight/2);
        [_floatBtn setImage:[UIImage imageNamed:@"add_note"] forState:(UIControlStateNormal)];
        [_floatBtn addTarget:self action:@selector(clickFloatBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _floatBtn;
}

- (NSMutableArray *)logMessages{
    if (!_logMessages) {
        _logMessages = [[NSMutableArray alloc] init];
    }
    return _logMessages;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
