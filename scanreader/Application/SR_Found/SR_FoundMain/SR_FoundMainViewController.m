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

#import "SR_InterPageViewController.h"

@interface SR_FoundMainViewController ()<addBtnDelegate,UIAlertViewDelegate,textViewSendBtnDelegate,imageViewSendBtnDelegate,voiceViewSendBtnDelegate>
@property(nonatomic,assign)BOOL isSelectBookClub;
@property(nonatomic,strong)NSMutableArray * bookClubs;
@property(nonatomic,strong)NSMutableArray * dynamicInfos;
@property(nonatomic,assign)NSInteger bookClubPageIndex;
@property(nonatomic,assign)NSInteger dynamicInfoPageIndex;
@property(nonatomic,strong)UIButton * floatBtn;
@property(nonatomic,strong)SR_ActionSheetTextView * actionSheetTextView;
@property(nonatomic,strong)SR_ActionSheetImageView * actionSheetImageView;
@property(nonatomic,strong)SR_ActionSheetVoiceView * actionSheetVoiceView;
@property(nonatomic,strong)AVPlayer * remotePlayer;
@end

@implementation SR_FoundMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"发现";
    
    UIBarButtonItem * mineItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fx_twoman"] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickMineItem)];
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fx_ss"] style:(UIBarButtonItemStyleDone) target:self action:@selector(clickSearchItem)];
    self.navigationItem.rightBarButtonItems = @[mineItem,searchItem];
    
    [self.view addSubview:self.floatBtn];
 
    self.tableView.av_footer = [AVFooterRefresh footerRefreshWithScrollView:self.tableView footerRefreshingBlock:^{
        [self loadData];
    }];
    //[self relogin]; //重登陆这个后面再考虑
    [self getListAll:PAGE_NUM pageIndex:self.dynamicInfoPageIndex];
    [self getBookClubList:PAGE_NUM pageIndex:self.bookClubPageIndex];
    
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.isSelectBookClub == YES ? self.bookClubs.count : self.dynamicInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 81;
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
            return 180;
        }else{
            return 146;
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
                SR_InterPageViewController * interPaageVC = [[SR_InterPageViewController alloc] init];
                [weakSelf.navigationController pushViewController:interPaageVC animated:YES];
            }];
            
            [cell addVoiceBtnBlock:^(NSString *voiceUrl) {
                [weakSelf playVoiceWithFilePath:voiceUrl];
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
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 125)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UIView * headerNotiBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 36)];
        headerView.backgroundColor = kColor(0xe2, 0xea, 0xe8);
        [headerView addSubview:headerNotiBgView];
        
        UIImageView * headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 3, 30, 30)];
        headerImageView.layer.cornerRadius = 15;
        headerImageView.image = [UIImage imageNamed:@"headerIcon"];
        [headerView addSubview:headerImageView];
        
        UILabel * notiLabel = [[UILabel alloc] initWithFrame:CGRectMake(headerImageView.frame.origin.x + headerImageView.frame.size.width + 10, 0, kScreenWidth - 30 - 10 - headerImageView.frame.size.width, 36)];
        notiLabel.text = @"Json刚才扫描了《天龙八部》";
        notiLabel.textColor = baseblackColor;
        notiLabel.font = [UIFont systemFontOfSize:13.0];
        notiLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:notiLabel];
        
        NSArray * titles = @[@"动态",@"读书会"];
        for (int i = 0; i < 2; i ++) {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i*(kScreenWidth/2), notiLabel.frame.origin.y + notiLabel.frame.size.height, kScreenWidth/2, 42)];
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
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, notiLabel.frame.size.height + notiLabel.frame.origin.y + 2, 0.5, 40)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:lineView];
        
        UIView * notiLabelBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, notiLabel.frame.origin.y + notiLabel.frame.size.height, kScreenWidth, 0.5)];
        notiLabelBottomLineView.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:notiLabelBottomLineView];
        
        return headerView;
    }else{
        return nil;
    }
}

- (void)playVoiceWithFilePath:(NSString *)filePath {
    self.remotePlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:filePath]];
    [self.remotePlayer play];
}


- (void)clickMineItem{
    self.hidesBottomBarWhenPushed = YES;
    SR_MineViewController * mineVC = [[SR_MineViewController alloc] init];
    [self.navigationController pushViewController:mineVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)clickHeaderBtn:(UIButton *)btn{
    static BOOL lastTag = 0;
    if (lastTag != btn.tag) {
        self.isSelectBookClub = !self.isSelectBookClub;
        [self.tableView reloadData];
        lastTag = btn.tag;
    }
}

- (void)clickFloatBtn{
    SR_AddBtnView * addBtnView = [[SR_AddBtnView alloc] initAlertView];
    addBtnView.delegate = self;
    [addBtnView show];
}

- (void)clickAddBtnView:(NSInteger)tag{
    if (tag == 0) {
        SR_ActionSheetTextView * textView = [[SR_ActionSheetTextView alloc] initActionSheetWith:nil text:nil];
        textView.delegate = self;
        self.actionSheetTextView = textView;
        [textView show];
    }else if (tag == 1){
        SR_ActionSheetImageView * imageView = [[SR_ActionSheetImageView alloc] initActionSheetWith:nil images:nil viewController:self];
        imageView.delegate = self;
        self.actionSheetImageView = imageView;
        [imageView show];
    }else{
        SR_ActionSheetVoiceView * voiceView = [[SR_ActionSheetVoiceView alloc] initActionSheetWith:nil voices:nil viewController:self];
        //voiceView.delegate = self;
        self.actionSheetVoiceView = voiceView;
        [voiceView show];
    }
}

///做没有对象的笔记
- (void)clickTextViewSendBtn:(NSString *)title text:(NSString *)text{
    SSLog(@"title:%@ content:%@",title,text);
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken,@"type":NOTE_TYPE_TEXT,
                             @"title":title,@"content":text};
    MBProgressHUD * hud = [[MBProgressHUD  alloc] initWithView:self.tableView];
    [hud showAnimated:YES];
    [httpTools post:SAVE_NOTE andParameters:param success:^(NSDictionary *dic) {
        [hud hideAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"笔记创建成功"];
        [self.actionSheetTextView dismiss];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [SVProgressHUD showErrorWithStatus:@"笔记创建失败"];
    }];
}

- (void)clickImageViewSendBtn:(NSString *)title images:(NSArray *)images{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken,@"type":NOTE_TYPE_PIX,
                             @"title":title};
    //这里的提示不起作用，用户可能会重复点发送按钮，
    MBProgressHUD * hud = [[MBProgressHUD  alloc] initWithView:self.tableView];
    [hud showAnimated:YES];
    [httpTools uploadImage:SAVE_NOTE parameters:param images:images success:^(NSDictionary *dic) {
        SSLog(@"save pic:%@",dic);
        [hud hideAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"笔记创建成功"];
        [self.actionSheetImageView dismiss];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [SVProgressHUD showErrorWithStatus:@"笔记创建失败"];
    }];
}

- (void)relogin{
    NSString * phoneNumber = [UserInfo getUserPhoneNumber];
    NSString * password = [UserInfo getUserPassword];
    
    NSDictionary * param = @{@"username":phoneNumber,@"password":password};
    [httpTools post:LOGIN andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"relogin:%@",dic);
        if ([dic[@"status"] isEqualToString:@"1"]) {
            NSDictionary * userDic = dic[@"data"][@"user"];
            [UserInfo saveUserAvatarWith:userDic[@"avatar"]];
            [UserInfo saveUserIDWith:userDic[@"id"]];
            [UserInfo saveUserTokenWith:dic[@"data"][@"user_token"]];
            [UserInfo saveUserNameWith:userDic[@"username"]];
        }else{//可能是token过期,就需要重新登录
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"获取该账号信息失败，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[SR_LoginViewController alloc] init];
}

- (void)loadData{
    if (self.isSelectBookClub) {
        [self getListAll:PAGE_NUM pageIndex:self.dynamicInfoPageIndex];
    }else{
        [self getBookClubList:PAGE_NUM pageIndex:self.bookClubPageIndex];
    }
}

///获取笔记以及收藏列表,这个列表就是动态的列表
- (void)getListAll:(NSInteger)pageNum pageIndex:(NSInteger)pageIndex{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSString * userId = [UserInfo getUserId];
    NSDictionary * param = @{@"user_id":userId,@"limit":limit,@"page":page,@"mode":@"1"};
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
            noteModel.user.user_id = item[@"user"][@"id"];
            [self.dynamicInfos addObject:noteModel];
        }
        self.dynamicInfoPageIndex = (self.dynamicInfos.count/PAGE_NUM) + (self.dynamicInfos.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
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
        self.bookClubPageIndex = (self.bookClubs.count/PAGE_NUM) + (self.bookClubs.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
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


@end
