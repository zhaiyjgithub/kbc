//
//  SR_InterPageDetailTextViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/8/31.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SR_InterPageTextFrameModel.h"
@interface SR_InterPageDetailTextViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * contentLabel;
@property(nonatomic,strong)SR_InterPageTextFrameModel * textFrameModel;
@end
