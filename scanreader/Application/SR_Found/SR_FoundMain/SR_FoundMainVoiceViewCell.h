//
//  SR_FoundMainVoiceViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/13.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SR_FoundMainVoiceViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIButton * voiceBtn;
@property(nonatomic,strong)UIImageView * subtitleImageView;
@property(nonatomic,strong)UILabel * subtitleLabel;
@property(nonatomic,strong)UILabel * messageAndMembersLabel;
@property(nonatomic,strong)UIButton * headerBtn;
@end
