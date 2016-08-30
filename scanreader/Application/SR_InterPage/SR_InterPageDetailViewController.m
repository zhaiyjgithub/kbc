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

#define PAGE_TYPY_1 @"1"
#define PAGE_TYPY_2 @"2"
#define PAGE_TYPY_3 @"3"
#define PAGE_TYPY_4 @"4"
#define PAGE_TYPY_5 @"5"
#define PAGE_TYPY_6 @"6"
#define PAGE_TYPY_7 @"7"
#define PAGE_TYPY_8 @"8"
#define PAGE_TYPY_9 @"9"

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SR_InterPageTitleFrameModel * titleFrameModel = self.dataSource[0];
    return 85 + titleFrameModel.contentHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"SR_InterPageDetailTitleViewCell";
    SR_InterPageDetailTitleViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SR_InterPageDetailTitleViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    cell.titleFrameModel = self.dataSource[0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}


- (void)getPageLIstModelItem{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:GET_PAGE_ONE_ITEM andParameters:@{@"id":self.pageListModel.pageId} success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        SSLog(@"page detail:%@",dic);
        SR_InterPageDetailItemModel * detailItemModel = [SR_InterPageDetailItemModel modelWithDictionary:dic[@"data"][@"record"]];
        SR_InterPageTitleFrameModel * titleFrameModel = [[SR_InterPageTitleFrameModel alloc] init];
        titleFrameModel.detailItemModel = detailItemModel;
        [self.dataSource addObject:titleFrameModel];
        
        
        detailItemModel.modelDescription = dic[@"data"][@"record"][@"description"];
        self.interPageModel = detailItemModel;
        for (NSDictionary * moduleItemModel in detailItemModel.moduleList) {
            SR_InterPageDetailItemMoudleListItemModel *  moduleListItemModel = [SR_InterPageDetailItemMoudleListItemModel modelWithDictionary:moduleItemModel];
            SSLog(@"type:%@",moduleListItemModel.type);
            [self.dataSource addObject:moduleListItemModel];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
