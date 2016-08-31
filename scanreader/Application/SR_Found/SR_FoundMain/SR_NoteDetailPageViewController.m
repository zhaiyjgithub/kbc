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

@interface SR_NoteDetailPageViewController ()
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,strong)AVPlayer * remotePlayer;
@end

@implementation SR_NoteDetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记详情";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
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
        return cell;
    }else if ([self.noteModel.type isEqualToString:NOTE_TYPE_PIX]){
        NSString * cellId = @"SR_NoteDetailPageImageViewCell";
        SR_NoteDetailPageImageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_NoteDetailPageImageViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.noteModel = self.noteModel;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
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
            [weakSelf playVoiceWithFilePath:filePath];
        }];
        
        [cell addDeleteBtnblock:^(NSInteger tag) {
            SSLog(@"delete tag:%ld",tag);
            [weakSelf.dataSource removeObjectAtIndex:tag];
            NSMutableArray * itemJsons = [NSMutableArray new];
            for (SR_BookClubNoteResourceModel * resurceModel in weakSelf.dataSource) {
                NSMutableDictionary * itemJson = [resurceModel modelToJSONObject];
                itemJson[@"id"] = resurceModel.resource_id;
                SSLog(@"itemJson:%@",itemJson);
                [itemJsons addObject:itemJson];
            }
            weakSelf.noteModel.resourceList = itemJsons;
            weakSelf.cellHeight =  (90)*(weakSelf.noteModel.resourceList.count) + 135;
            [weakSelf.tableView reloadData];
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
    if ([noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {
        CGSize contentSize = [noteModel.content sizeForFont:[UIFont systemFontOfSize:14.0] size:CGSizeMake(kScreenWidth - 30, MAXFLOAT) mode:(NSLineBreakByWordWrapping)];
        self.cellHeight = contentSize.height + 10 + 135;
    }else if ([noteModel.type isEqualToString:NOTE_TYPE_PIX]){
        self.cellHeight =  (300 + 5)*noteModel.resourceList.count + 135;
    }else if ([noteModel.type isEqualToString:NOTE_TYPE_VOICE]){
        self.cellHeight =  (90)*noteModel.resourceList.count + 135;
    }
}

- (void)playVoiceWithFilePath:(NSString *)filePath {
    self.remotePlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:filePath]];
    [self.remotePlayer play];
}


@end