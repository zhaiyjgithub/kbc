//
//  SR_OthersMineViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_UserInfoModel.h"

typedef void(^othersMineCellBlock)(UITextView * textView);

@interface SR_OthersMineViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * levelabel;
@property(nonatomic,strong)UILabel * OAthuabel;
@property(nonatomic,strong)UITextView * messageTextView;
@property(nonatomic,strong)SR_UserInfoModel * userModel;
@property(nonatomic,strong)othersMineCellBlock block;
- (void)addBlock:(othersMineCellBlock)block;
@end
