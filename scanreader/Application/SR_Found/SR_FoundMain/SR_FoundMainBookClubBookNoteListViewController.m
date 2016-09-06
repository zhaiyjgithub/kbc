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

@interface SR_FoundMainBookClubBookNoteListViewController ()<textViewSendBtnDelegate,imageViewSendBtnDelegate,voiceViewSendBtnDelegate,addBtnDelegate>
@property(nonatomic,strong)UIButton * floatBtn;
@property(nonatomic,assign)NSInteger bookClubNotePageIndex;
@end

@implementation SR_FoundMainBookClubBookNoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记列表";
    [self.view addSubview:self.floatBtn];
    [self getBookMarkList:PAGE_NUM pageIndex:self.bookClubNotePageIndex];
}


- (void)clickAddBtnView:(NSInteger)tag{
    if (tag == 0) {
        SR_ActionSheetTextView * textView = [[SR_ActionSheetTextView alloc] initActionSheetWith:nil text:nil];
        textView.delegate = self;
        textView.requestType = NOTE_REQUSERT_TYPE_SAVE;
        textView.book_id = self.bookModel.book_id;
        [textView show];
    }else if (tag == 1){
        SR_ActionSheetImageView * imageView = [[SR_ActionSheetImageView alloc] initActionSheetWith:nil images:nil viewController:self];
        imageView.delegate = self;
        imageView.requestType = NOTE_REQUSERT_TYPE_SAVE;
        imageView.book_id = self.bookModel.book_id;
        [imageView show];
    }else{
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
    return 145;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //还要判断不同类型
    NSString * cellId = @"SR_FoundMainTextViewCell";
    SR_FoundMainTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SR_FoundMainTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    cell.noteModel = self.dataSource[indexPath.row];
    [cell addBlock:^{
        SSLog(@"click header btn");
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SR_FoundMainBookClubItemDetailViewController * itemDetailVC = [[SR_FoundMainBookClubItemDetailViewController alloc] init];
    [self.navigationController pushViewController:itemDetailVC animated:YES];
}

- (void)getBookMarkList:(NSInteger)pageNum  pageIndex:(NSInteger)pageIndex{
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSString * userId = [UserInfo getUserId];
    NSDictionary * param = @{@"book_id":self.bookModel.book_id,@"user_id":userId,@"mode":@"2",@"limit":limit,@"page":page};
    [httpTools post:GET_NOTE_LIST_ALL andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"%@笔记:%@",self.bookModel.title,dic);
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
    SR_AddBtnView * addBtnView = [[SR_AddBtnView alloc] initAlertView];
    addBtnView.delegate = self;
    [addBtnView show];
}

@end
