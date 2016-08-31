//
//  SR_InterPageDetailVideoViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/8/31.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SR_InterPageTextFrameModel.h"

@interface SR_InterPageDetailVideoViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)MPMoviePlayerController * mpc;
@property(nonatomic,strong)UIButton * playBtn;
@property(nonatomic,strong)UIView * videoBgView;
@property(nonatomic,strong)SR_InterPageTextFrameModel * textFrameModel;
@end
