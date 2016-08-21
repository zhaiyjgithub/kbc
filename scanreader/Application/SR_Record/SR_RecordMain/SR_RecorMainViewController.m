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

@interface SR_RecorMainViewController ()
@property(nonatomic,assign)NSInteger selectedTagIndex;
@property(nonatomic,strong)NSMutableArray * noteList;
@property(nonatomic,strong)NSMutableArray * collectionList;
@property(nonatomic,strong)NSMutableArray * scanList;
@property(nonatomic,assign)NSInteger collectionPageIndex;
@property(nonatomic,assign)NSInteger notePageIndex;
@end

@implementation SR_RecorMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"记录";
    self.selectedTagIndex = 0;
    self.tableView.av_footer = [AVFooterRefresh footerRefreshWithScrollView:self.tableView footerRefreshingBlock:^{
        [self loadData];
    }];

    [self getListAll:PAGE_NUM pageIndex:self.notePageIndex mode:NOTE_MODE_NOTE];//暂时只获取笔记列表
    [self getListAll:PAGE_NUM pageIndex:self.collectionPageIndex mode:NOTE_MODE_COLLECTION];//暂时只获取收藏列表
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
        return 146;
    }else{
        return 64;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedTagIndex == 0 || self.selectedTagIndex == 2) {
        //根据type 来区分笔记的类型
        //        1文字
        //        2图片
        //        3语音
        //        4收藏
        SR_BookClubBookNoteModel * noteModel = self.noteList[indexPath.row];
        if (self.selectedTagIndex == 2) {
            noteModel = self.collectionList[indexPath.row];
        }
        if ([noteModel.type isEqualToString:NOTE_TYPE_TEXT]) {//文字信息
            NSString * cellId = @"SR_FoundMainTextViewCell";
            SR_FoundMainTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            [cell addBlock:^{
                SSLog(@"click header btn");
            }];
            return cell;
        }else if ([noteModel.type isEqualToString:NOTE_TYPE_PIX]){//图片
            NSString * cellId = @"SR_FoundMainImageViewCell";
            SR_FoundMainImageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainImageViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            [cell addBlock:^{
                SSLog(@"click header btn");
            }];
            return cell;
            
        }else if ([noteModel.type isEqualToString:NOTE_TYPE_VOICE]){//语音
            NSString * cellId = @"SR_FoundMainVoiceViewCell";
            SR_FoundMainVoiceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainVoiceViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            __weak typeof(self) weakSelf = self;
            [cell addBlock:^{
                SSLog(@"click header btn");
            }];
            [cell addInterBlock:^{
                SR_InterPageViewController * interPaageVC = [[SR_InterPageViewController alloc] init];
                [weakSelf.navigationController pushViewController:interPaageVC animated:YES];
            }];
            return cell;
        }else{//收藏
            NSString * cellId = @"SR_FoundMainCollectionViewCell";
            SR_FoundMainCollectionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_FoundMainCollectionViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            [cell addBlock:^{
                SSLog(@"click header btn");
            }];
            
            return cell;
        }
    }else{//扫描列表
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
            cell.textLabel.text = @"2016-07-28 14:00";
            cell.detailTextLabel.text = @"扫描了25页 天龙八部";
        }else{//收藏
            cell.textLabel.text = @"2016-07-28 14:00";
            cell.detailTextLabel.text = @"收藏了25页 论语";
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
        SR_FoundMainBookClubItemDetailViewController * itemDetailVC = [[SR_FoundMainBookClubItemDetailViewController alloc] init];
        [self.navigationController pushViewController:itemDetailVC animated:YES];
    }else{//扫描、收藏
        SR_InterPageViewController * interPageVC = [[SR_InterPageViewController alloc] init];
        [self.navigationController pushViewController:interPageVC animated:YES];
    }
    
}

- (void)clickHeaderBtn:(UIButton *)btn{
    SSLog(@"tag:%d",btn.tag);
    self.selectedTagIndex = btn.tag;
    [self.tableView reloadData];
}

- (void)getListAll:(NSInteger)pageNum pageIndex:(NSInteger)pageIndex mode:(NSString *)mode{
    NSString * userId = [UserInfo getUserId];
    NSString * limit = [NSString stringWithFormat:@"%d",pageNum];
    NSString * page = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary * param = @{@"user_id":userId,@"limit":limit,@"page":page,@"mode":mode};
    [httpTools post:GET_LIST_ALL andParameters:param success:^(NSDictionary *dic) {
       // SSLog(@"get lsit all:%@",dic);
         NSArray * list = dic[@"data"][@"list"];
        for (NSDictionary * item in list) {
            SR_BookClubBookNoteModel * noteModel = [SR_BookClubBookNoteModel modelWithDictionary:item];
            noteModel.note_id = item[@"id"];
            noteModel.book.book_id = item[@"book"][@"id"];
            noteModel.user.user_id = item[@"user"][@"id"];
            if ([mode isEqualToString:NOTE_MODE_COLLECTION]) {//请求收藏列表
                [self.collectionList addObject:noteModel];
            }else if ([mode isEqualToString:NOTE_MODE_NOTE]){//请求笔记列表
                [self.noteList addObject:noteModel];
            }
        }
        self.notePageIndex = (self.noteList.count/PAGE_NUM) + (self.noteList.count%PAGE_NUM > 0 ? 1 : 0);
        self.collectionPageIndex = (self.collectionList.count/PAGE_NUM) + (self.collectionList.count%PAGE_NUM > 0 ? 1 : 0);
        [self.tableView.av_footer endFooterRefreshing];
        [self.tableView reloadData];
        //区分不同类型的笔记进行不同model的转换
    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}

- (void)loadData{
    if (self.selectedTagIndex == 0) {
        [self getListAll:PAGE_NUM pageIndex:self.notePageIndex mode:NOTE_MODE_NOTE];//暂时只获取笔记列表
    }else if (self.selectedTagIndex == 1){
        [self getListAll:PAGE_NUM pageIndex:self.collectionPageIndex mode:NOTE_MODE_COLLECTION];//暂时只获取收藏列表
    }else{
        //获取扫描列表
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
