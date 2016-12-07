//
//  SR_FoundMainDYnamicBookMarkListViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_FoundMainBookClubBookNoteListViewController.h"
#import "globalHeader.h"
#import "SR_FoundMainVoiceViewCell.h"
#import "SR_FoundMainTextViewCell.h"
#import "SR_FoundMainBookClubItemDetailViewController.h"
#import "SR_BookClubBookNoteModel.h"
#import "httpTools.h"
#import "UserInfo.h"
#import "requestAPI.h"
#import "SR_ActionSheetImageView.h"
#import "SR_ActionSheetVoiceView.h"
#import "SR_ActionSheetTextView.h"
#import "SR_AddBtnView.h"
#import "SR_OthersMineViewController.h"
#import "SR_InterPageListModel.h"
#import "SR_MineViewController.h"
#import "SR_InterPageDetailViewController.h"
#import "SR_FoundMainImageViewCell.h"
#import "SR_FoundMainCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "SR_NoteDetailPageViewController.h"
#import <MBProgressHUD.h>

@interface SR_FoundMainBookClubBookNoteListViewController ()<textViewSendBtnDelegate,imageViewSendBtnDelegate,voiceViewSendBtnDelegate,addBtnDelegate>
@property(nonatomic,strong)UIButton * floatBtn;
@property(nonatomic,assign)NSInteger bookClubNotePageIndex;
@property(nonatomic,strong)AVPlayer * remotePlayer;
@property(nonatomic,assign)NSInteger lastTag;
@property(nonatomic,assign)BOOL isFinishedPlay;
@property(nonatomic,strong)AVPlayerItem * playerItem;
@end

@implementation SR_FoundMainBookClubBookNoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记列表";
    [self.view addSubview:self.floatBtn];
    [self getBookMarkList:PAGE_NUM pageIndex:self.bookClubNotePageIndex];
}


- (void)clickAddBtnView:(NSInteger)tag{
    if (tag == 4) {
        SR_ActionSheetTextView * textView = [[SR_ActionSheetTextView alloc] initActionSheetWith:nil text:nil];
        textView.delegate = self;
        textView.requestType = NOTE_REQUSERT_TYPE_SAVE;
        textView.book_id = self.bookModel.book_id;
        [textView show];
    }else if (tag == 3){
        SR_ActionSheetImageView * imageView = [[SR_ActionSheetImageView alloc] initActionSheetWith:nil images:nil viewController:self];
        imageView.delegate = self;
        imageView.requestType = NOTE_REQUSERT_TYPE_SAVE;
        imageView.book_id = self.bookModel.book_id;
        [imageView show];
    }else if (tag == 2){
        SR_ActionSheetVoiceView * voiceView = [[SR_ActionSheetVoiceView alloc] initActionSheetWith:nil voices:nil viewController:self];
        voiceView.delegate = self;
        voiceView.requestType = NOTE_REQUSERT_TYPE_SAVE;
        voiceView.book_id = self.bookModel.book_id;
        [voiceView show];
    }
}

///做没有对象的笔记
- (void)clickTextViewSendBtn:(NSString *)title text:(NSString *)text{
    SSLog(@"title:%@ content:%@",title,text);
    [self.dataSource removeAllObjects];
    self.bookClubNotePageIndex = 0;
    [self getBookMarkList:PAGE_NUM pageIndex:self.bookClubNotePageIndex];
}

- (void)clickImageViewSendBtn:(NSString *)title images:(NSArray *)images{
    SSLog(@"image title:%@",title);
    [self.dataSource removeAllObjects];
    self.bookClubNotePageIndex = 0;
    [self getBookMarkList:PAGE_NUM pageIndex:self.bookClubNotePageIndex];
}

- (void)clickVoiceViewSendBtn:(NSString *)title text:(NSString *)text{
    SSLog(@"voice title:%@",title);
    [self.dataSource removeAllObjects];
    self.bookClubNotePageIndex = 0;
    [self getBookMarkList:PAGE_NUM pageIndex:self.bookClubNotePageIndex];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SR_BookClubBookNoteModel * noteModel = self.dataSource[indexPath.row];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //还要判断不同类型
//    NSString * cellId = @"SR_FoundMainTextViewCell";
//    SR_FoundMainTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        cell = [[SR_FoundMainTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
//    }
//    cell.noteModel = self.dataSource[indexPath.row];
//    [cell addBlock:^{
//        SSLog(@"click header btn");
//    }];
//    return cell;
    //根据type 来区分笔记的类型
    //        1文字
    //        2图片
    //        3语音
    //        4收藏
    SR_BookClubBookNoteModel * noteModel = self.dataSource[indexPath.row];
    if ([noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {//文字信息
        NSString * cellId = @"SR_FoundMainTextViewCell";
        SR_FoundMainTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_FoundMainTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.noteModel = self.dataSource[indexPath.row];
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
                SR_BookClubBookNoteModel * noteModel = weakSelf.dataSource[indexPath.row];
                otherVC.userModel = noteModel.user;
                [weakSelf.navigationController pushViewController:otherVC animated:YES];
                weakSelf.hidesBottomBarWhenPushed = NO;
            }
        }];
        [cell addInterBlock:^{
            SR_BookClubBookNoteModel * noteModel = weakSelf.dataSource[indexPath.row];
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
        cell.noteModel = self.dataSource[indexPath.row];
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
                SR_BookClubBookNoteModel * noteModel = weakSelf.dataSource[indexPath.row];
                otherVC.userModel = noteModel.user;
                [weakSelf.navigationController pushViewController:otherVC animated:YES];
                weakSelf.hidesBottomBarWhenPushed = NO;
            }
        }];
        [cell addInterBlock:^{
            SR_BookClubBookNoteModel * noteModel = weakSelf.dataSource[indexPath.row];
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
        
        [cell addImageBlock:^(NSString *imagePath) {
            SR_PreScanView * scanView = [[SR_PreScanView alloc] initPreScanViewWithImagePath:imagePath];
            [scanView show];
        }];
        
        return cell;
        
    }else if ([noteModel.type isEqualToString:NOTE_TYPE_VOICE]){//语音
        NSString * cellId = @"SR_FoundMainVoiceViewCell";
        SR_FoundMainVoiceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_FoundMainVoiceViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.noteModel = self.dataSource[indexPath.row];
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
                SR_BookClubBookNoteModel * noteModel = weakSelf.dataSource[indexPath.row];
                otherVC.userModel = noteModel.user;
                [weakSelf.navigationController pushViewController:otherVC animated:YES];
                weakSelf.hidesBottomBarWhenPushed = NO;
            }
        }];
        [cell addInterBlock:^{
            SR_BookClubBookNoteModel * noteModel = weakSelf.dataSource[indexPath.row];
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
        cell.noteModel = self.dataSource[indexPath.row];
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
                SR_BookClubBookNoteModel * noteModel = weakSelf.dataSource[indexPath.row];
                otherVC.userModel = noteModel.user;
                [weakSelf.navigationController pushViewController:otherVC animated:YES];
                weakSelf.hidesBottomBarWhenPushed = NO;
            }
        }];
        [cell addInterBlock:^{
            SR_BookClubBookNoteModel * noteModel = weakSelf.dataSource[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SR_BookClubBookNoteModel * noteModel = self.dataSource[indexPath.row];
    SR_NoteDetailPageViewController * noteDetailVC = [[SR_NoteDetailPageViewController alloc] init];
    noteDetailVC.noteModel = noteModel;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noteDetailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

- (void)getBookMarkList:(NSInteger)pageNum  pageIndex:(NSInteger)pageIndex{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"book_id":self.bookModel.book_id,@"mode":@"2",@"limit":limit,@"page":page};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:GET_NOTE_LIST_ALL andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"%@笔记:%@",self.bookModel.title,dic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray * list = dic[@"data"][@"list"];
        for (NSDictionary * item in list) {
            SR_BookClubBookNoteModel * noteModel = [SR_BookClubBookNoteModel modelWithDictionary:item];
            noteModel.note_id = item[@"id"];
            noteModel.book.book_id = item[@"book"][@"id"];
            noteModel.user.user_id = item[@"user"][@"id"];
            [self.dataSource addObject:noteModel];
        }
        self.bookClubNotePageIndex = (self.dataSource.count/PAGE_NUM) + (self.dataSource.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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

- (void)clickFloatBtn{
    SR_AddBtnView * addBtnView = [[SR_AddBtnView alloc] initAlertViewWithType:SR_BTN_TYPE_NORMAL];
    addBtnView.delegate = self;
    [addBtnView show];
}

@end
