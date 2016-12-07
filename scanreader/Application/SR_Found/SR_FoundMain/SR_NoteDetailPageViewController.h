//
//  SR_NoteDetailPageViewController.h
//  scanreader
//
//  Created by jbmac01 on 16/8/28.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseTableViewController.h"
#import "SR_BookClubBookNoteModel.h"

@protocol SR_NoteDetailPageViewControllerDelegate <NSObject>

@optional
- (void)deleteSelectedRowNote:(NSInteger)row;

@end

@interface SR_NoteDetailPageViewController : SR_BaseTableViewController
@property(nonatomic,strong)SR_BookClubBookNoteModel * noteModel;
@property(nonatomic,weak)id<SR_NoteDetailPageViewControllerDelegate>delegate;
@property(nonatomic,assign)NSInteger selectedRow;
@end
