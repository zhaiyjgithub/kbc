//
//  SR_ActionSheetVoiceView.h
//  scanreader
//
//  Created by admin on 16/7/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol voiceViewSendBtnDelegate <NSObject>

@optional
- (void)clickVoiceViewSendBtn:(NSString *)title text:(NSString *)text;
@end

@interface SR_ActionSheetVoiceView : UIView <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UIButton * handerView;
@property(nonatomic,weak)id<voiceViewSendBtnDelegate>delegate;
@property(nonatomic,strong)UITextField * titleTextField;
@property(nonatomic,copy)NSString * articleTitle;
@property(nonatomic,strong)NSMutableArray * voices;
@property(nonatomic,strong)UIButton * sendBtn;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,strong)UIButton * voiceBtn;
@property(nonatomic,strong)UIViewController * viewController;
@property (strong,nonatomic)AVAudioRecorder  *recorder;
@property (strong,nonatomic)AVAudioPlayer  *player;
@property(nonatomic,strong)AVPlayer * remotePlayer;
@property (strong,nonatomic)NSString         *recordFileName;
@property (strong,nonatomic)NSString         *recordFilePath;
@property(nonatomic,assign)BOOL isTimeOut;
@property(nonatomic,strong)NSMutableArray * filePathsDataSource;

- (id)initActionSheetWith:(NSString *)title voices:(NSArray *)voices viewController:(UIViewController *)viewController;
- (void)show;
- (void)dismiss;
@end
