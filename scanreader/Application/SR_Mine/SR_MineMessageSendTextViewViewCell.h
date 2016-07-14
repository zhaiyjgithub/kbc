//
//  SR_MineMessageSendTextViewViewCell.h
//  scanreader
//
//  Created by jbmac01 on 16/7/14.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^mineMessageSendTextViewViewCellBlock)(UITextView * textView);

@interface SR_MineMessageSendTextViewViewCell : UITableViewCell
@property(nonatomic,strong)UITextView * messageTextView;
@property(nonatomic,strong)mineMessageSendTextViewViewCellBlock block;
- (void)addBlock:(mineMessageSendTextViewViewCellBlock)block;
@end
