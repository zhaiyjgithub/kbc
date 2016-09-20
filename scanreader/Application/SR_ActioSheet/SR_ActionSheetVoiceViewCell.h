//
//  SR_ActionSheetVoiceViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/8/29.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SR_ActionSheetVoiceViewCellBlock)(UIButton * btn);

@interface SR_ActionSheetVoiceViewCell : UITableViewCell
@property(nonatomic,strong)UIButton * voiceBtn;
@property(nonatomic,strong)UIView * barView;
@property(nonatomic,assign)float voiceTimeLength;
@property(nonatomic,strong)UIView * voiceProgressView;
@property(nonatomic,strong)SR_ActionSheetVoiceViewCellBlock block;
- (void)addBlock:(SR_ActionSheetVoiceViewCellBlock)block;
@end
