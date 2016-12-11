//
//  SR_MineMessageListViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/22.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RKNotificationHub.h>
#import "SR_MineMessageModel.h"
#import "SR_MineMessagePeopleModel.h"
@interface SR_MineMessageListViewCell : UITableViewCell
@property(nonatomic,strong)YYAnimatedImageView * headerImageView;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)RKNotificationHub * hub;
@property(nonatomic,assign)NSInteger unreadMessageCount;
@property(nonatomic,strong)SR_MineMessagePeopleModel * messagePeopleModel;

@end
