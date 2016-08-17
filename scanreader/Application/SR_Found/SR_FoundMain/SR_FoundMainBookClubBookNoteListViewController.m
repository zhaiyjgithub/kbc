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

@interface SR_FoundMainBookClubBookNoteListViewController ()

@end

@implementation SR_FoundMainBookClubBookNoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记列表";
    [self getBookMarkList:@"70" page:@"1"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(clickBtn)];
}

///创建笔记
- (void)clickBtn{
    NSString * userId = [UserInfo getUserUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"title":@"滕王阁序笔记1",@"content":@"俊采星驰",@"book_id":self.bookModel.book_id,@"user_id":userId,@"user_token":userToken,@"type":@"1"};
    [httpTools post:SAVE_NOTE andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"创建笔记:%@",dic);
    } failure:^(NSError *error) {
        
    }];
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

- (void)getBookMarkList:(NSString *)limit page:(NSString *)page{
    NSString * userId = [UserInfo getUserUserId];
    NSDictionary * param = @{@"book_id":self.bookModel.book_id,@"user_id":userId,@"mode":@"2",@"limit":limit,@"page":page};
    [httpTools post:GET_LIST_ALL andParameters:param success:^(NSDictionary *dic) {
        SSLog(@"%@笔记:%@",self.bookModel.title,dic);
        NSArray * list = dic[@"data"][@"list"];
        for (NSDictionary * item in list) {
            SR_BookClubBookNoteModel * markModel = [SR_BookClubBookNoteModel modelWithDictionary:item];
            markModel.note_id = item[@"id"];
            [self.dataSource addObject:markModel];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

@end
