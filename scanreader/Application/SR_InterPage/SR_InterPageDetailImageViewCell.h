//
//  SR_InterPageDetailImageViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/8/31.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_InterPageTextFrameModel.h"

@interface SR_InterPageDetailImageViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIView * imagebgView;
@property(nonatomic,strong)SR_InterPageTextFrameModel * textFrameModel;
@end
