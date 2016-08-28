//
//  SR_MineMessageSendDialogMineSendViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/8/28.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_MessageDialogLabel.h"
#import "SR_MineMessageFrameModel.h"
@interface SR_MineMessageSendDialogMineSendViewCell : UITableViewCell
@property(nonatomic,strong)YYAnimatedImageView * headerImageView;
@property(nonatomic,strong)SR_MessageDialogLabel * messageLabel;
@property(nonatomic,strong)SR_MineMessageFrameModel * frameModel;
@property(nonatomic,strong)UILabel * timeLabel;

@end
