//
//  SR_InterPageDetailTitleViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/8/30.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_InterPageTitleFrameModel.h" 

@interface SR_InterPageDetailTitleViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * contentLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UILabel * bookFriendsLabel;
@property(nonatomic,strong)UIImageView * messageImageView;
@property(nonatomic,strong)UIImageView * bookFriendsView;
@property(nonatomic,strong)SR_InterPageTitleFrameModel * titleFrameModel;
@end
