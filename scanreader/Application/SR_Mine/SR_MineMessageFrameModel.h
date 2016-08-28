//
//  SR_MineMessageFrameModel.h
//  scanreader
//
//  Created by jbmac01 on 16/8/28.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SR_MineMessageModel.h"
@interface SR_MineMessageFrameModel : NSObject
@property(nonatomic,assign)CGSize cellMessageLableSize;
@property(nonatomic,strong)SR_MineMessageModel * messageModel;
@end
