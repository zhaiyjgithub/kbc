//
//  SR_NoteDetailPageViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/8/28.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_NoteDetailPageViewController.h"
#import "SR_NoteDetailPageTextViewCell.h"
#import "SR_NoteDetailPageImageViewCell.h"
#import "globalHeader.h"
#import "requestAPI.h"
#import "SR_NoteDetailPageVoiceViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UserInfo.h"
#import "httpTools.h"
#import "SR_InterPageViewController.h"
#import "SR_ActionSheetTextView.h"
#import "SR_ActionSheetImageView.h"
#import "SR_ActionSheetVoiceView.h"
#import <MBProgressHUD.h>
#import <SVProgressHUD.h>
#import "SR_InterPageListModel.h"
#import "SR_InterPageDetailViewController.h"
#import "SR_InterPageListModel.h"
#import "SR_AddBtnView.h"

@interface SR_NoteDetailPageViewController ()<textViewSendBtnDelegate,imageViewSendBtnDelegate,voiceViewSendBtnDelegate,UIAlertViewDelegate,addBtnDelegate>
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,strong)AVPlayer * remotePlayer;
@property(nonatomic,strong)AVPlayerItem * playerItem;
@property(nonatomic,assign)int lastTag;
@property(nonatomic,assign)BOOL isFinishedPlay;
@property(nonatomic,strong)NSTimer * voiceTimer;
@property(nonatomic,strong)UIButton * voiceBtn;
@property(nonatomic,strong)SR_ActionSheetTextView * actionSheetTextView;
@property(nonatomic,strong)SR_ActionSheetImageView * actionSheetImageView;
@property(nonatomic,strong)SR_ActionSheetVoiceView * actionSheetVoiceView;
@property(nonatomic,strong)UIButton * floatBtn;
@end

@implementation SR_NoteDetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记详情";
    
    self.lastTag = -1;
    
    UIBarButtonItem * editBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickEidtItem)];
    UIBarButtonItem * interPageBarItem = [[UIBarButtonItem alloc] initWithTitle:@"互动页" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickinterPageItem)];
    //如果看别人的笔记就不会出现编辑窗口
    if ([self.noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {
        if (self.noteModel.page.page_id) {
            self.navigationItem.rightBarButtonItems = @[editBarItem,interPageBarItem];
        }else{
            self.navigationItem.rightBarButtonItems = @[editBarItem];
        }
    }else{//现在看的是别人的笔记，可以出现浮动按钮
        [self.view addSubview:self.floatBtn];
        if (self.noteModel.page.page_id) {
            self.navigationItem.rightBarButtonItems = @[interPageBarItem];
        }
    }
}

///先检测是否登录超时了。
- (void)clickEidtItem{
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
            
            if ([self.noteModel.type isEqualToString:NOTE_TYPE_TEXT]){
                SR_ActionSheetTextView * textView = [[SR_ActionSheetTextView alloc] initActionSheetWith:self.noteModel.title text:self.noteModel.content];
                textView.delegate = self;
                textView.requestType = NOTE_REQUSERT_TYPE_UPDATE;
                textView.noteId = self.noteModel.note_id;
                self.actionSheetTextView = textView;
                [textView show];
            }else if ([self.noteModel.type isEqualToString:NOTE_TYPE_PIX]){
                SR_ActionSheetImageView * imageView = [[SR_ActionSheetImageView alloc] initActionSheetWith:self.noteModel.title images:nil viewController:self];
                imageView.delegate = self;
                imageView.requestType = NOTE_REQUSERT_TYPE_UPDATE;
                imageView.noteId = self.noteModel.note_id;
                self.actionSheetImageView = imageView;
                [imageView show];
            }else if ([self.noteModel.type isEqualToString:NOTE_TYPE_VOICE]){
                SR_ActionSheetVoiceView * voiceView = [[SR_ActionSheetVoiceView alloc] initActionSheetWith:self.noteModel.title voices:nil viewController:self];
                voiceView.requestType = NOTE_REQUSERT_TYPE_UPDATE;
                voiceView.noteId = self.noteModel.note_id;
                voiceView.delegate = self;
                self.actionSheetVoiceView = voiceView;
                [voiceView show];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

///做没有对象的笔记
- (void)clickTextViewSendBtn:(NSString *)title text:(NSString *)text{
    if ([self.noteModel.user.user_id isEqualToString:[UserInfo getUserId]]){
        [self getNewModel];
    }else{//看别人的笔记没有了编辑，但是可以做笔记
        SSLog(@"title:%@ content:%@",title,text);
        [[NSNotificationCenter defaultCenter] postNotificationName:SR_NOTI_CREATE_PAGE_NOTE object:nil userInfo:@{SR_NOTI_CREATE_PAGE_NOTE_KEY_1:@"SR_NOTI_CREATE_PAGE_NOTE_KEY_1"}];
    }
}

///添加新的图片文件
- (void)clickImageViewSendBtn:(NSString *)title images:(NSArray *)images{
    if ([self.noteModel.user.user_id isEqualToString:[UserInfo getUserId]]){
        [self getNewModel];
    }else{
        SSLog(@"image title:%@",title);
        [[NSNotificationCenter defaultCenter] postNotificationName:SR_NOTI_CREATE_PAGE_NOTE object:nil userInfo:@{SR_NOTI_CREATE_PAGE_NOTE_KEY_1:@"SR_NOTI_CREATE_PAGE_NOTE_KEY_1"}];
    }
}

- (void)clickVoiceViewSendBtn:(NSString *)title text:(NSString *)text{
    if ([self.noteModel.user.user_id isEqualToString:[UserInfo getUserId]]){
        [self getNewModel];
    }else{
        SSLog(@"voice title:%@",title);
        [[NSNotificationCenter defaultCenter] postNotificationName:SR_NOTI_CREATE_PAGE_NOTE object:nil userInfo:@{SR_NOTI_CREATE_PAGE_NOTE_KEY_1:@"SR_NOTI_CREATE_PAGE_NOTE_KEY_1"}];
    }
}

- (void)getNewModel{
    [httpTools post:GET_NOTE_ONE andParameters:@{@"id":self.noteModel.note_id} success:^(NSDictionary *dic) {
        SSLog(@"最新的状态:%@",dic);
        SR_BookClubBookNoteModel * noteModel = [SR_BookClubBookNoteModel modelWithDictionary:dic[@"data"][@"record"]];
        noteModel.note_id = dic[@"data"][@"record"][@"id"];
        if ([dic[@"data"][@"record"][@"book"] isKindOfClass:[NSDictionary class]]) {
            noteModel.book.book_id = dic[@"data"][@"record"][@"book"][@"id"];
        }
        noteModel.user.user_id = dic[@"data"][@"record"][@"user"][@"id"];
        self.noteModel = noteModel;
        //重新计算高度
        if ([self.noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {
            CGSize contentSize = [self.noteModel.content sizeForFont:[UIFont systemFontOfSize:14.0] size:CGSizeMake(kScreenWidth - 30, MAXFLOAT) mode:(NSLineBreakByWordWrapping)];
            self.cellHeight = contentSize.height + 10 + 135;
        }else if ([self.noteModel.type isEqualToString:NOTE_TYPE_PIX]){
            self.cellHeight =  (280 + 10)*self.noteModel.resourceList.count + 135;
        }else if ([self.noteModel.type isEqualToString:NOTE_TYPE_VOICE]){
            self.cellHeight =  (90)*self.noteModel.resourceList.count + 135;
        }
        [self.dataSource removeAllObjects];
        for (NSDictionary * item in self.noteModel.resourceList) {
            SR_BookClubNoteResourceModel * resourceModel = [SR_BookClubNoteResourceModel modelWithDictionary:item];
            resourceModel.resource_id = item[@"id"];
            [self.dataSource addObject:resourceModel];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)clickinterPageItem{
    self.hidesBottomBarWhenPushed = YES;
    NSString * pageId = self.noteModel.page.page_id;
    SR_InterPageDetailViewController * pageDetailVC = [[SR_InterPageDetailViewController alloc] init];
    SR_InterPageListModel * PageListModel = [[SR_InterPageListModel alloc] init];
    PageListModel.pageId = pageId;
    pageDetailVC.pageListModel = PageListModel;
    [self.navigationController pushViewController:pageDetailVC animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {
        NSString * cellId = @"SR_NoteDetailPageTextViewCell";
        SR_NoteDetailPageTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_NoteDetailPageTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.noteModel = self.noteModel;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf = self;
        [cell addInterBtnBlock:^{
            SR_InterPageListModel * interPageModel = [[SR_InterPageListModel alloc] init];
            interPageModel.content = @"";
            interPageModel.pageId = weakSelf.noteModel.page.page_id;
            interPageModel.member_total = weakSelf.noteModel.member_total;
            interPageModel.note_total = weakSelf.noteModel.note_total;
            interPageModel.picture = @"";
            interPageModel.time_create = weakSelf.noteModel.time_create;
            interPageModel.time_create = weakSelf.noteModel.time_create;
            SR_InterPageDetailViewController * interPageDetailVC = [[SR_InterPageDetailViewController alloc] init];
            interPageDetailVC.pageListModel = interPageModel;
            weakSelf.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:interPageDetailVC animated:YES];
            weakSelf.hidesBottomBarWhenPushed = NO;
        }];
        return cell;
    }else if ([self.noteModel.type isEqualToString:NOTE_TYPE_PIX]){
        NSString * cellId = @"SR_NoteDetailPageImageViewCell";
        SR_NoteDetailPageImageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_NoteDetailPageImageViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        __weak typeof(self) weakSelf = self;
        cell.resourceList = self.dataSource;
        cell.noteModel = self.noteModel;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addDeleteBtnblock:^(NSInteger tag) {
            SSLog(@"delete tag:%ld",tag);
            [weakSelf showDeleteAlertView:tag];
        }];
        [cell addInterBtnBlock:^{
            SR_InterPageListModel * interPageModel = [[SR_InterPageListModel alloc] init];
            interPageModel.content = @"";
            interPageModel.pageId = weakSelf.noteModel.page.page_id;
            interPageModel.member_total = weakSelf.noteModel.member_total;
            interPageModel.note_total = weakSelf.noteModel.note_total;
            interPageModel.picture = @"";
            interPageModel.time_create = weakSelf.noteModel.time_create;
            interPageModel.time_create = weakSelf.noteModel.time_create;
            SR_InterPageDetailViewController * interPageDetailVC = [[SR_InterPageDetailViewController alloc] init];
            interPageDetailVC.pageListModel = interPageModel;
            weakSelf.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:interPageDetailVC animated:YES];
            weakSelf.hidesBottomBarWhenPushed = NO;
        }];
        return cell;
    }else if ([self.noteModel.type isEqualToString:NOTE_TYPE_VOICE]){
        NSString * cellId = @"SR_NoteDetailPageVoiceViewCell";
        SR_NoteDetailPageVoiceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_NoteDetailPageVoiceViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.resourceList = self.dataSource;
        cell.noteModel = self.noteModel;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf = self;
        [cell addVoicBtnblock:^(NSString *filePath, UIButton *voiceBtn,float voiceTimeLength) {
            weakSelf.voiceBtn = voiceBtn;
             [weakSelf playVoiceWithFilePath:filePath row:(voiceBtn.tag - 100) voiceBtn:voiceBtn voiceTimeLength:voiceTimeLength];
        }];
        
        [cell addDeleteBtnblock:^(NSInteger tag) {
            [weakSelf deleteResource:tag];
        }];
        
        [cell addInterBtnBlock:^{
            SR_InterPageListModel * interPageModel = [[SR_InterPageListModel alloc] init];
            interPageModel.content = @"";
            interPageModel.pageId = weakSelf.noteModel.page.page_id;
            interPageModel.member_total = weakSelf.noteModel.member_total;
            interPageModel.note_total = weakSelf.noteModel.note_total;
            interPageModel.picture = @"";
            interPageModel.time_create = weakSelf.noteModel.time_create;
            interPageModel.time_create = weakSelf.noteModel.time_create;
            SR_InterPageDetailViewController * interPageDetailVC = [[SR_InterPageDetailViewController alloc] init];
            interPageDetailVC.pageListModel = interPageModel;
            weakSelf.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:interPageDetailVC animated:YES];
            weakSelf.hidesBottomBarWhenPushed = NO;
        }];

        return cell;
    }else{
        NSString * cellId = @"SR_NoteDetailPageTextViewCell";
        SR_NoteDetailPageTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_NoteDetailPageTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.noteModel = self.noteModel;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf = self;
        [cell addInterBtnBlock:^{
            SR_InterPageListModel * interPageModel = [[SR_InterPageListModel alloc] init];
            interPageModel.content = @"";
            interPageModel.pageId = weakSelf.noteModel.page.page_id;
            interPageModel.member_total = weakSelf.noteModel.member_total;
            interPageModel.note_total = weakSelf.noteModel.note_total;
            interPageModel.picture = @"";
            interPageModel.time_create = weakSelf.noteModel.time_create;
            interPageModel.time_create = weakSelf.noteModel.time_create;
            SR_InterPageDetailViewController * interPageDetailVC = [[SR_InterPageDetailViewController alloc] init];
            interPageDetailVC.pageListModel = interPageModel;
            weakSelf.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:interPageDetailVC animated:YES];
            weakSelf.hidesBottomBarWhenPushed = NO;
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setNoteModel:(SR_BookClubBookNoteModel *)noteModel{
    _noteModel = noteModel;
    for (NSDictionary * item in self.noteModel.resourceList) {
        SR_BookClubNoteResourceModel * resourceModel = [SR_BookClubNoteResourceModel modelWithDictionary:item];
        resourceModel.resource_id = item[@"id"];
        [self.dataSource addObject:resourceModel];
    }
    if ([noteModel.type isEqualToString:NOTE_TYPE_PIX]){
        self.cellHeight =  (280 + 10)*noteModel.resourceList.count + 135;
    }else if ([noteModel.type isEqualToString:NOTE_TYPE_VOICE]){
        self.cellHeight =  (90)*noteModel.resourceList.count + 135;
    }else{
        CGSize contentSize = [noteModel.content sizeForFont:[UIFont systemFontOfSize:14.0] size:CGSizeMake(kScreenWidth - 30, MAXFLOAT) mode:(NSLineBreakByWordWrapping)];
        self.cellHeight = contentSize.height + 10 + 135;
    }
}

- (void)playVoiceWithFilePath:(NSString *)filePath row:(int)row voiceBtn:(UIButton *)voiceBtn voiceTimeLength:(float)voiceTimeLength{
    if (self.lastTag != row) {
        if (self.lastTag != -1) {//如果不是第一次打开的就可以获取上一次的语音的cell
            NSInteger index = self.lastTag;
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            SR_NoteDetailPageVoiceViewCell * lastVoiceViewCell = (SR_NoteDetailPageVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            UIView * voicebgView = lastVoiceViewCell.voicebgView;
            //注意这两个的tag的起点是不一样的
            UIView * voiceProgressView = (UIView *)[voicebgView viewWithTag:10000 + index];
            [voiceProgressView.layer removeAllAnimations];//清除上一次的动画
        }
        
        self.isFinishedPlay = NO;
        self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:filePath]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.playerItem];

        self.remotePlayer = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
        [self.remotePlayer play];
        
        NSInteger index = row;
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        SR_NoteDetailPageVoiceViewCell * lastVoiceViewCell = (SR_NoteDetailPageVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        UIView * voicebgView = lastVoiceViewCell.voicebgView;

        
        UIView * voiceProgressView = (UIView *)[voicebgView viewWithTag:index + 10000];
        UIView * barView = (UIView *)[voicebgView viewWithTag:index + 1000];
        voiceProgressView.backgroundColor = baseColor;
        CGRect voiceProgressViewFrame = voiceProgressView.frame;
        [UIView animateWithDuration:voiceTimeLength animations:^{
            voiceProgressView.frame = CGRectMake(voiceProgressViewFrame.origin.x, voiceProgressViewFrame.origin.y, barView.frame.size.width, barView.frame.size.height);
            voiceProgressView.backgroundColor = kColor(215, 215, 215);
        } completion:^(BOOL finished) {
            voiceProgressView.frame = CGRectMake(voiceProgressView.frame.origin.x, voiceProgressView.frame.origin.y, 1, barView.frame.size.height);
        }];
        
        self.lastTag = row;
    }else{
        //在这里查询当前播放的状态，如果在播放就停止，已经播放完毕之后就重新播放
        if (!self.isFinishedPlay) {//点击了正在播放就可以终止播放
            NSInteger index = row;
            //停止当前的progressView动画
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            SR_NoteDetailPageVoiceViewCell * currentVoiceViewCell = (SR_NoteDetailPageVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            UIView * voicebgView = currentVoiceViewCell.voicebgView;
            //注意这两个的tag的起点是不一样的
            UIView * voiceProgressView = (UIView *)[voicebgView viewWithTag:10000 + index];
            [voiceProgressView.layer removeAllAnimations];//清除上一次的动画
            
            [self.remotePlayer pause];
            self.isFinishedPlay = YES;
          //  self.lastTag = row;//这里相当于重新来过
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
            NSInteger currentIndex = voiceBtn.tag - 100;
            
            //注意这两个的tag的起点是不一样的
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            SR_NoteDetailPageVoiceViewCell * VoiceViewCell = (SR_NoteDetailPageVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            UIView * voicebgView = VoiceViewCell.voicebgView;
            UIView * voiceProgressView = (UIView *)[voicebgView viewWithTag:10000 + currentIndex];
            UIView * barView = (UIView *)[voicebgView viewWithTag:1000 + currentIndex];
            
            voiceProgressView.backgroundColor = baseColor;
            CGRect voiceProgressViewFrame = voiceProgressView.frame;
            [UIView animateWithDuration:voiceTimeLength animations:^{
                voiceProgressView.frame = CGRectMake(voiceProgressViewFrame.origin.x, voiceProgressViewFrame.origin.y, barView.frame.size.width, barView.frame.size.height);
                voiceProgressView.backgroundColor = kColor(215, 215, 215);
            } completion:^(BOOL finished) {
                voiceProgressView.frame = CGRectMake(barView.frame.origin.x, barView.frame.origin.y, 1, barView.frame.size.height);
            }];
            
         //   self.lastTag = row;//这里也是相当于重新播放
        }
    }
}

- (void)playerItemDidReachEnd{
    NSLog(@"播放完毕");
    self.isFinishedPlay = YES;
}

- (void)showDeleteAlertView:(NSInteger)index{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除这个资源" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = index;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self deleteResource:alertView.tag - 100];
    }
}

- (void)deleteResource:(NSInteger)index{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    SR_BookClubNoteResourceModel * resourceModel = self.dataSource[index];
    NSDictionary * param = @{@"id":resourceModel.resource_id,@"user_id":userId,@"user_token":userToken};
    [httpTools post:DELETE_REOURCE andParameters:param success:^(NSDictionary *dic) {
       // SSLog(@"delete dic:%@",dic);
        
        [self.dataSource removeObjectAtIndex:index];
        NSMutableArray * itemJsons = [NSMutableArray new];
        for (SR_BookClubNoteResourceModel * resurceModel in self.dataSource) {
            NSMutableDictionary * itemJson = [resurceModel modelToJSONObject];
            itemJson[@"id"] = resurceModel.resource_id;
          //  SSLog(@"itemJson:%@",itemJson);
            [itemJsons addObject:itemJson];
        }
        //重新计算高度
        self.noteModel.resourceList = itemJsons;
        if ([self.noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {
            CGSize contentSize = [self.noteModel.content sizeForFont:[UIFont systemFontOfSize:14.0] size:CGSizeMake(kScreenWidth - 30, MAXFLOAT) mode:(NSLineBreakByWordWrapping)];
            self.cellHeight = contentSize.height + 10 + 135;
        }else if ([self.noteModel.type isEqualToString:NOTE_TYPE_PIX]){
            self.cellHeight =  (280 + 10)*self.noteModel.resourceList.count + 135;
        }else if ([self.noteModel.type isEqualToString:NOTE_TYPE_VOICE]){
            self.cellHeight =  (90)*self.noteModel.resourceList.count + 135;
        }
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        
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

@end
