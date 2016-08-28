//
//  SR_NoteDetailPageViewController.h
//  scanreader
//
//  Created by jbmac01 on 16/8/28.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_BaseTableViewController.h"
#import "SR_BookClubBookNoteModel.h"

@interface SR_NoteDetailPageViewController : SR_BaseTableViewController
@property(nonatomic,strong)SR_BookClubBookNoteModel * noteModel;
@end
