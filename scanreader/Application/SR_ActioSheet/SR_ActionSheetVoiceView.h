//
//  SR_ActionSheetVoiceView.h
//  scanreader
//
//  Created by admin on 16/7/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol voiceViewSendBtnDelegate <NSObject>

@optional
- (void)clickSendBtn:(NSString *)title text:(NSString *)text;
@end

@interface SR_ActionSheetVoiceView : UIView <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIButton * handerView;
@property(nonatomic,weak)id<voiceViewSendBtnDelegate>delegate;
@property(nonatomic,strong)UITextField * titleTextField;
@property(nonatomic,copy)NSString * articleTitle;
@property(nonatomic,strong)NSMutableArray * voices;
@property(nonatomic,strong)UIButton * sendBtn;
@property(nonatomic,strong)UITableView * tableView;
@end
