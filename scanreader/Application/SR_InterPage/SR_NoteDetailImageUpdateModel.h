//
//  SR_NoteDetailImageUpdateModel.h
//  scanreader
//
//  Created by jbmac01 on 16/9/1.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SR_NoteDetailImageUpdateModel : NSObject
@property(nonatomic,assign)BOOL isNeedToUpdateResource;//是否需要提交的
@property(nonatomic,strong)UIImage * image;//路径
@end
