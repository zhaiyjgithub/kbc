//
//  SR_NoteDetailVoiceUpdateModel.h
//  scanreader
//
//  Created by jbmac01 on 16/9/1.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SR_NoteDetailVoiceUpdateModel : NSObject
@property(nonatomic,assign)BOOL isNeedToUpdateResource;//是否需要提交的
@property(nonatomic,copy)NSString * voicePath;//路径
@end
