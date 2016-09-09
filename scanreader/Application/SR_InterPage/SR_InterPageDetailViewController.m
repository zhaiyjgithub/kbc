//
//  SR_InterPageDetailViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/8/30.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_InterPageDetailViewController.h"
#import "globalHeader.h"
#import "requestAPI.h"
#import "httpTools.h"
#import <MBProgressHUD.h>
#import "SR_InterPageDetailItemModel.h"
#import "SR_InterPageDetailTitleViewCell.h"
#import "SR_InterPageTextFrameModel.h"
#import "SR_InterPageDetailTextViewCell.h"
#import "SR_InterPageDetailImageViewCell.h"
#import "videoViewController.h"
#import "SR_InterPageDetailVideoViewCell.h"

#define MODEL_TYPE_TITLE @"1"
#define MODEL_TYPE_TEXT @"2"
#define MODEL_TYPE_PIX @"3"
#define MODEL_TYPE_VEDIO @"4"

@interface SR_InterPageDetailViewController ()
@property(nonatomic,strong)SR_InterPageDetailItemModel * interPageModel;
@end

@implementation SR_InterPageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self getPageLIstModelItem];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SR_InterPageTitleFrameModel * titleFrameModel = self.dataSource[indexPath.row];
        return 85 + titleFrameModel.contentHeight;
    }else{
        SR_InterPageTextFrameModel * textFrameModel = self.dataSource[indexPath.row];
        if ([textFrameModel.MoudleListItemModel.type isEqualToString:PAGE_TYPY_1] ||
            [textFrameModel.MoudleListItemModel.type isEqualToString:PAGE_TYPY_2] ||
            [textFrameModel.MoudleListItemModel.type isEqualToString:PAGE_TYPY_3]
            ) {
            return 55 + textFrameModel.contentHeight;
        }else if ([textFrameModel.MoudleListItemModel.type isEqualToString:PAGE_TYPY_7] || [textFrameModel.MoudleListItemModel.type isEqualToString:PAGE_TYPY_8]){
            return 50 + textFrameModel.contentHeight;
        }else if ([textFrameModel.MoudleListItemModel.type isEqualToString:PAGE_TYPY_5]){
            return 80 +(kScreenWidth - 40)*0.75;
        }else{
            return 55 + textFrameModel.contentHeight;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource.count) {
        if (indexPath.row) {//标题不需要
            SR_InterPageTextFrameModel * textFrameModel = self.dataSource[indexPath.row];
            if ([textFrameModel.MoudleListItemModel.type isEqualToString:PAGE_TYPY_5]) {
                SR_InterPageDetailVideoViewCell * videoCell = (SR_InterPageDetailVideoViewCell *)cell;
                [videoCell.mpc pause];
                videoCell.playBtn.hidden = NO;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString * cellId = @"SR_InterPageDetailTitleViewCell";
        SR_InterPageDetailTitleViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_InterPageDetailTitleViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.titleFrameModel = self.dataSource[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }else{
        SR_InterPageTextFrameModel * textFrameModel = self.dataSource[indexPath.row];
        if ([textFrameModel.MoudleListItemModel.type isEqualToString:PAGE_TYPY_1] ||
            [textFrameModel.MoudleListItemModel.type isEqualToString:PAGE_TYPY_2] ||
            [textFrameModel.MoudleListItemModel.type isEqualToString:PAGE_TYPY_3]
            ) {

            NSString * cellId = @"SR_InterPageDetailTextViewCell";
            SR_InterPageDetailTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_InterPageDetailTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            cell.textFrameModel = self.dataSource[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }else if ([textFrameModel.MoudleListItemModel.type isEqualToString:PAGE_TYPY_7]){
            NSString * cellId = @"SR_InterPageDetailImageViewCell";
            SR_InterPageDetailImageViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_InterPageDetailImageViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            cell.textFrameModel = self.dataSource[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }else if ([textFrameModel.MoudleListItemModel.type isEqualToString:PAGE_TYPY_5]){
            NSString * cellId = @"SR_InterPageDetailVideoViewCell";
            SR_InterPageDetailVideoViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_InterPageDetailVideoViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            cell.textFrameModel = self.dataSource[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            NSString * cellId = @"SR_InterPageDetailTextViewCell";
            SR_InterPageDetailTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[SR_InterPageDetailTextViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
            }
            cell.textFrameModel = self.dataSource[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (void)getPageLIstModelItem{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:GET_PAGE_ONE_ITEM andParameters:@{@"id":self.pageListModel.pageId} success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        SSLog(@"page detail:%@",dic);
        
        //添加标题
        SR_InterPageDetailItemModel * detailItemModel = [SR_InterPageDetailItemModel modelWithDictionary:dic[@"data"][@"record"]];
        SR_InterPageTitleFrameModel * titleFrameModel = [[SR_InterPageTitleFrameModel alloc] init];
        titleFrameModel.detailItemModel = detailItemModel;
        titleFrameModel.type = MODEL_TYPE_TITLE;
        [self.dataSource addObject:titleFrameModel];
        
        //添加module list
        detailItemModel.modelDescription = dic[@"data"][@"record"][@"description"];
        self.interPageModel = detailItemModel;
        for (NSDictionary * moduleItemModel in detailItemModel.moduleList) {
            SR_InterPageDetailItemMoudleListItemModel *  moduleListItemModel = [SR_InterPageDetailItemMoudleListItemModel modelWithDictionary:moduleItemModel];            SR_InterPageTextFrameModel * textFrameModel = [[SR_InterPageTextFrameModel alloc] init];
            textFrameModel.MoudleListItemModel = moduleListItemModel;
            [self.dataSource addObject:textFrameModel];
            
            SSLog(@"type:%@",moduleListItemModel.type);
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
