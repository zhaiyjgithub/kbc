//
//  SR_FoundMainVoiceSelfViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/21.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^foundMainVoiceSelfViewCellBlock)(void);

@interface SR_FoundMainVoiceSelfViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIButton * voiceBtn;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UIButton * headerBtn;
@property(nonatomic,strong)foundMainVoiceSelfViewCellBlock  block;
- (void)addBlock:(foundMainVoiceSelfViewCellBlock )block;
@end
