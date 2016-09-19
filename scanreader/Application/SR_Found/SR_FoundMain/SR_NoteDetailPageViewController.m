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

@interface SR_NoteDetailPageViewController ()<textViewSendBtnDelegate,imageViewSendBtnDelegate,voiceViewSendBtnDelegate,UIAlertViewDelegate>
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,strong)AVPlayer * remotePlayer;
@property(nonatomic,strong)SR_ActionSheetTextView * actionSheetTextView;
@property(nonatomic,strong)SR_ActionSheetImageView * actionSheetImageView;
@property(nonatomic,strong)SR_ActionSheetVoiceView * actionSheetVoiceView;
@end

@implementation SR_NoteDetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记详情";
    UIBarButtonItem * editBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickEidtItem)];
    UIBarButtonItem * interPageBarItem = [[UIBarButtonItem alloc] initWithTitle:@"互动页" style:(UIBarButtonItemStyleDone) target:self action:@selector(clickinterPageItem)];
    //如果看别人的笔记就不会出现编辑窗口
    if ([self.noteModel.user.user_id isEqualToString:[UserInfo getUserId]]) {
        if (self.noteModel.page.page_id) {
            self.navigationItem.rightBarButtonItems = @[editBarItem,interPageBarItem];
        }else{
            self.navigationItem.rightBarButtonItems = @[editBarItem];
        }
    }else{
        if (self.noteModel.page.page_id) {
            self.navigationItem.rightBarButtonItems = @[interPageBarItem];
        }
    }
}

- (void)clickEidtItem{
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

///做没有对象的笔记
- (void)clickTextViewSendBtn:(NSString *)title text:(NSString *)text{
    [self getNewModel];
}

///添加新的图片文件
- (void)clickImageViewSendBtn:(NSString *)title images:(NSArray *)images{
    [self getNewModel];
}

- (void)clickVoiceViewSendBtn:(NSString *)title text:(NSString *)text{
    [self getNewModel];
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
        [cell addVoicBtnblock:^(NSString *filePath) {
            [weakSelf playVoiceWithFilePath:filePath row:indexPath.row];
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

- (void)playVoiceWithFilePath:(NSString *)filePath row:(int)row{
    static int lastTag = -1;
    if (lastTag != row) {
        self.remotePlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:filePath]];
        [self.remotePlayer play];
        lastTag = row;
    }else{
        [self.remotePlayer pause];
        lastTag = -1;
    }
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
        SSLog(@"delete dic:%@",dic);
        
        [self.dataSource removeObjectAtIndex:index];
        NSMutableArray * itemJsons = [NSMutableArray new];
        for (SR_BookClubNoteResourceModel * resurceModel in self.dataSource) {
            NSMutableDictionary * itemJson = [resurceModel modelToJSONObject];
            itemJson[@"id"] = resurceModel.resource_id;
            SSLog(@"itemJson:%@",itemJson);
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


@end
