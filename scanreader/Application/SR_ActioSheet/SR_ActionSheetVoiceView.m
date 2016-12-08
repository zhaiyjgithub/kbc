//
//  SR_ActionSheetVoiceView.m
//  scanreader
//
//  Created by admin on 16/7/24.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_ActionSheetVoiceView.h"
#import "globalHeader.h"
#import "SR_ActionSheetVoiceViewCell.h"
#import <MBProgressHUD.h>
#import "UserInfo.h"
#import "requestAPI.h"
#import "httpTools.h"
#import <SVProgressHUD.h>


#define ALERT_VIEW_TAG_DISMIESS  (-1)

@implementation SR_ActionSheetVoiceView
- (id)initActionSheetWith:(NSString *)title voices:(NSArray *)voices viewController:(UIViewController *)viewController{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        self.articleTitle = title;
        [self.voices addObjectsFromArray:voices];
        self.viewController = viewController;
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
        
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)setupView{
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, sizeHeight(50))];
    leftView.backgroundColor = [UIColor whiteColor];
    self.titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, sizeHeight(50))];
    self.titleTextField.placeholder = @"请输入笔记标题";
    self.titleTextField.text = self.articleTitle;
    self.titleTextField.textColor = baseblackColor;
    self.titleTextField.font = [UIFont systemFontOfSize:16.0];
    self.titleTextField.layer.borderWidth = 1.0;
    self.titleTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.titleTextField.layer.cornerRadius = 3.0;
    self.titleTextField.delegate = self;
    self.titleTextField.leftViewMode = UITextFieldViewModeAlways;
    self.titleTextField.leftView = leftView;
    [self addSubview:self.titleTextField];
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, self.titleTextField.frame.origin.y + self.titleTextField.frame.size.height + sizeHeight(10), kScreenWidth - 30, sizeHeight(230)) style:UITableViewStylePlain];
    //当前使用原生的分割线，不适用图片的方式加载分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tintColor=[UIColor whiteColor];
    _tableView = tableView;
    [self addSubview:self.tableView];
    
    UIView * voiceView = [[UIView alloc] initWithFrame:CGRectMake(0, sizeHeight(400) - sizeHeight(30 + 54) , kScreenWidth, sizeHeight((30 + 54)))];
    voiceView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:voiceView];
    
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(0, 0, sizeHeight(70), sizeHeight(70));
    btn.center = CGPointMake(kScreenWidth/2, voiceView.frame.size.height/2.0);
    btn.backgroundColor = baseColor;
    btn.layer.cornerRadius = sizeHeight(70)/2.0;
    [btn setTitle:@"按住" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btn setTitle:@"松开" forState:(UIControlStateHighlighted)];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateHighlighted)];
    [btn addTarget:self action:@selector(clickVoice) forControlEvents:(UIControlEventTouchUpInside)];
    [btn addTarget:self action:@selector(touchdown) forControlEvents:(UIControlEventTouchDown)];
    self.voiceBtn = btn;
    [voiceView addSubview:btn];
    
    UIButton * sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sendBtn.frame = CGRectMake(kScreenWidth - 12 - 44, 10, 44, 44);
    [sendBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    [sendBtn setTitleColor:baseColor forState:(UIControlStateNormal)];
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [sendBtn addTarget:self action:@selector(clickSendBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [voiceView addSubview:sendBtn];
    
}

- (void)clickSendBtn:(UIButton *)sendBtn{
    if (!self.titleTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入笔记标题"];
        return;
    }
    
    if (!self.filePathsDataSource.count) {
        [SVProgressHUD showErrorWithStatus:@"请添加至少一条语音笔记"];
        return;
    }
    
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    sendBtn.enabled = NO;
    
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * baseParam = @{@"user_id":userId,@"user_token":userToken,@"type":NOTE_TYPE_VOICE,
                             @"title":self.titleTextField.text};
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithDictionary:baseParam];

    NSString * baseUrl = SAVE_NOTE;
    if ([self.requestType isEqualToString:NOTE_REQUSERT_TYPE_SAVE]) {
        baseUrl = SAVE_NOTE;
        if (self.book_id) {//创建有对象
            param[@"book_id"] = self.book_id;
        }
    }else if ([self.requestType isEqualToString:NOTE_REQUSERT_TYPE_UPDATE]){
        baseUrl = UPDATE_NOTE;
        if (self.noteId) {//更新笔记
            param[@"id"] = self.noteId;
        }
    }else if ([self.requestType isEqualToString:NOTE_REQUSERT_TYPE_SAVE]) {
        baseUrl = SAVE_NOTE;
        if (self.page_id) {//创建有对象
            param[@"page_id"] = self.page_id;
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.handerView animated:YES];
    [httpTools uploadVoice:baseUrl parameters:param voicesUrl:self.filePathsDataSource success:^(NSDictionary *dic) {
        [sendBtn setTitleColor:baseblackColor forState:(UIControlStateNormal)];
        sendBtn.enabled = YES;
        [MBProgressHUD hideHUDForView:self.handerView animated:YES];
        if ([dic[@"show"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:dic[@"msg"]];
        }
        for (NSString * filePath in self.filePathsDataSource) {
            [self deleteFile:filePath];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate conformsToProtocol:@protocol(voiceViewSendBtnDelegate)] && [self.delegate respondsToSelector:@selector(clickVoiceViewSendBtn:text:)]) {
                [self.delegate clickVoiceViewSendBtn:self.titleTextField.text text:@"none"];
            }
            [self dismiss];
        });
    } failure:^(NSError *error) {
        [sendBtn setTitleColor:baseblackColor forState:(UIControlStateNormal)];
        sendBtn.enabled = YES;
        [SVProgressHUD showErrorWithStatus:@"笔记创建失败"];
        [MBProgressHUD hideHUDForView:self.handerView animated:YES];
    }];
}

- (void)CountvoiceTimeLength{
    self.voiceTimeLength +=1;
}

///录制最多1min
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:59 target:self selector:@selector(timeout) userInfo:nil repeats:YES];
    self.voiceTimeLength = 0;
    self.voiceTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(CountvoiceTimeLength) userInfo:nil repeats:YES];
}

- (void)removeTimer{
    [self.timer invalidate];
    [self.voiceTimer invalidate];
    NSString * voiceTimeLength = [[NSString alloc] initWithFormat:@"%d",self.voiceTimeLength];
    [self.voiceTimeLengthArray addObject:voiceTimeLength];
}

//录制超时
- (void)timeout{
    [self.voiceBtn setHighlighted:NO];
    [self.voiceBtn setEnabled:NO];
    [self removeTimer];
    SSLog(@"timeout");
    [self stopRecord];
    self.isTimeOut = YES;
}

///松手,少于1s就不停止录制，继续录制直到1s为止
- (void)clickVoice{
    [self.voiceBtn setEnabled:YES];
    [self removeTimer];
    if (!self.isTimeOut) {
        [self stopRecord];
    }
    NSLog(@"song shou");
}

///按下
- (void)touchdown{
    NSURL * soundUrl = [[NSBundle mainBundle] URLForResource:@"sound.caf" withExtension:nil];
    self.localPlayer = [[AVPlayer alloc] initWithURL:soundUrl];
    [self.localPlayer play];
    [self addTimer];
    SSLog(@"touch down");
    [self beginRecord];
}

///录音完成
- (void)stopRecord{
    NSURL * soundUrl = [[NSBundle mainBundle] URLForResource:@"sound.caf" withExtension:nil];
    self.localPlayer = [[AVPlayer alloc] initWithURL:soundUrl];
    [self.localPlayer play];
    if (self.recorder.isRecording){//录音中
        //停止录音
        [self.recorder stop];
        NSLog(@"停止录音");
        self.recordingView.hidden = YES;
       // NSURL * url = [NSURL fileURLWithPath:self.recordFilePath];
        NSString * targetFilePath = [[NSString alloc] initWithString:self.recordFilePath];
        [self.filePathsDataSource addObject:targetFilePath];
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:self.filePathsDataSource.count - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:(UITableViewRowAnimationBottom)];
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    }
}

///开始录音
- (void)beginRecord{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&setCategoryError];
    
    if(setCategoryError){
        NSLog(@"setCategoryError:%@", [setCategoryError description]);
    }
    //根据当前时间生成文件名
    self.recordFileName = [self GetCurrentTimeString];
    //获取路径
    self.recordFilePath = [self GetPathByFileName:self.recordFileName ofType:@"wav"];
    //初始化录音
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    
    self.recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:self.recordFilePath]
                                               settings:recordSetting
                                                  error:nil];
    //准备录音
    if ([self.recorder prepareToRecord]){
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        //开始录音
        if ([self.recorder record]){
            NSLog(@"开始录音");
            self.recordingView.hidden = NO;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filePathsDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"SR_ActionSheetVoiceViewCell";
    SR_ActionSheetVoiceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SR_ActionSheetVoiceViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    NSString * voiceTimeLength = [NSString stringWithFormat:@"%@s",self.voiceTimeLengthArray[indexPath.row]];
    [cell.voiceBtn setTitle:voiceTimeLength forState:(UIControlStateNormal)];
    __weak typeof(self) weakSelf = self;
    [cell addBlock:^(UIButton *btn) {
        if (btn.tag == 0) {
            SSLog(@"play");
            [weakSelf playVoiceWithFilePath:weakSelf.filePathsDataSource[indexPath.row] row:indexPath.row voiceTimeLength:[self.voiceTimeLengthArray[indexPath.row] floatValue]];
        }else{
            SSLog(@"delete");
            [weakSelf showDeleteAlertViewWithRow:indexPath.row];
        }
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)playVoiceWithFilePath:(NSString *)filePath row:(int)row voiceTimeLength:(float)voiceTimeLength{
    static int lastRow = -1;
    if (lastRow != row) {
        if (lastRow != -1) {//如果不是第一次打开的就可以获取上一次的语音的cell
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
            SR_ActionSheetVoiceViewCell * lastVoiceViewCell = (SR_ActionSheetVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            UIView * progressView = lastVoiceViewCell.voiceProgressView;
            [progressView.layer removeAllAnimations];//清除上一次的动画
        }
        self.isFinishedPlay = NO;

        self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:filePath]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.playerItem];
        
        self.remotePlayer = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
        [self.remotePlayer play];
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        SR_ActionSheetVoiceViewCell * voiceViewCell = (SR_ActionSheetVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        //
        voiceViewCell.voiceProgressView.backgroundColor = baseColor;
        CGRect voiceProgressViewFrame = voiceViewCell.voiceProgressView.frame;
        [UIView animateWithDuration:voiceTimeLength animations:^{
            voiceViewCell.voiceProgressView.frame = CGRectMake(voiceProgressViewFrame.origin.x, voiceProgressViewFrame.origin.y, voiceViewCell.barView.frame.size.width, voiceViewCell.barView.frame.size.height);
            voiceViewCell.voiceProgressView.backgroundColor = kColor(215, 215, 215);
        } completion:^(BOOL finished) {
            voiceViewCell.voiceProgressView.frame = CGRectMake(voiceViewCell.barView.frame.origin.x, voiceViewCell.barView.frame.origin.y, 1, voiceViewCell.barView.frame.size.height);
        }];
        
        lastRow = row;
    }else{
        //在这里查询当前播放的状态，如果在播放就停止，已经播放完毕之后就重新播放
        if (!self.isFinishedPlay) {//点击了正在播放就可以终止播放
            //停止当前的progressView动画
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            SR_ActionSheetVoiceViewCell * currentVoiceViewCell = (SR_ActionSheetVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            UIView * voiceProgressView = currentVoiceViewCell.voiceProgressView;
            [voiceProgressView.layer removeAllAnimations];
            
            [self.remotePlayer pause];
            self.isFinishedPlay = YES;
        }else{//已经完成播放的可以重新继续播放同一个语音
            self.isFinishedPlay = NO;
            self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:filePath]];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:self.playerItem];
            
            self.remotePlayer = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
            [self.remotePlayer play];
            
            //AVPlayerItem
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            SR_ActionSheetVoiceViewCell * voiceViewCell = (SR_ActionSheetVoiceViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            voiceViewCell.voiceProgressView.backgroundColor = baseColor;
            CGRect voiceProgressViewFrame = voiceViewCell.voiceProgressView.frame;
            [UIView animateWithDuration:voiceTimeLength animations:^{
                voiceViewCell.voiceProgressView.frame = CGRectMake(voiceProgressViewFrame.origin.x, voiceProgressViewFrame.origin.y, voiceViewCell.barView.frame.size.width, voiceViewCell.barView.frame.size.height);
                voiceViewCell.voiceProgressView.backgroundColor = kColor(215, 215, 215);
            } completion:^(BOOL finished) {
                voiceViewCell.voiceProgressView.frame = CGRectMake(voiceViewCell.barView.frame.origin.x, voiceViewCell.barView.frame.origin.y, 1, voiceViewCell.barView.frame.size.height);
            }];
        }
        
    }
}

- (void)playerItemDidReachEnd{
    NSLog(@"播放完毕");
    self.isFinishedPlay = YES;
}


- (void)showDeleteAlertViewWithRow:(NSInteger)row{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"要删除这条语音笔记吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = row;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == ALERT_VIEW_TAG_DISMIESS) {
        //如果确定丢弃已编辑内容
        if (buttonIndex == 1) {
            [self dismiss];
        }
    }else{
        if (buttonIndex) {
            //删除本地
            [self deleteFile:self.filePathsDataSource[alertView.tag]];
            [self.filePathsDataSource removeObjectAtIndex:alertView.tag];
            [self.voiceTimeLengthArray removeObjectAtIndex:alertView.tag];
            [self.tableView reloadData];
        }
    }
}

- (void)show{
    self.handerView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _handerView.frame = [UIScreen mainScreen].bounds;
    _handerView.backgroundColor = [UIColor clearColor];
    [_handerView addTarget:self action:@selector(clickHandleView) forControlEvents:(UIControlEventTouchUpInside)];
    [_handerView addSubview:self];
    
    [_handerView addSubview:self.recordingView];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    
    [UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _handerView.backgroundColor = kColorAlpha(0, 0, 0, 0.20);
        self.frame = CGRectMake(0, kScreenHeight - sizeHeight(400), kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)clickHandleView{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否放弃已编辑的内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = ALERT_VIEW_TAG_DISMIESS;
    [alertView show];
}

- (void)dismiss{
        //如果上传失败，还要删除本地的语音
    for (NSString * filePath in self.filePathsDataSource) {
        [self deleteFile:filePath];
    }
    [UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _handerView.backgroundColor = kColorAlpha(0, 0, 0, 0);
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [self.handerView removeFromSuperview];
    }];
}

    #pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGRect keyBoardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (!keyBoardRect.size.height) {
        return;
    }
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = CGRectMake(0, kScreenHeight - sizeHeight(400) - keyBoardRect.size.height/2, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished){
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = CGRectMake(0, kScreenHeight - sizeHeight(400), kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
}

#pragma mark - 生成当前时间字符串
- (NSString*)GetCurrentTimeString{
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}

#pragma mark - 生成文件路径
- (NSString*)GetPathByFileName:(NSString *)_fileName ofType:(NSString *)_type{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString* fileDirectory = [[[directory stringByAppendingPathComponent:_fileName]
                                stringByAppendingPathExtension:_type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return fileDirectory;
}

#pragma mark - 获取音频文件信息
- (NSString *)getVoiceFileInfoByPath:(NSString *)aFilePath convertTime:(NSTimeInterval)aConTime{
    
    NSInteger size = [self getFileSize:aFilePath]/1024;
    NSString *info = [NSString stringWithFormat:@"文件名:%@\n文件大小:%dkb\n",aFilePath.lastPathComponent,size];
    
    NSRange range = [aFilePath rangeOfString:@"wav"];
    if (range.length > 0) {
        AVAudioPlayer *play = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:aFilePath] error:nil];
        info = [info stringByAppendingFormat:@"文件时长:%f\n",play.duration];
    }
    
    if (aConTime > 0)
        info = [info stringByAppendingFormat:@"转换时间:%f",aConTime];
    return info;
}

#pragma mark - 获取文件大小
- (NSInteger) getFileSize:(NSString*) path{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else{
        return -1;
    }
}

#pragma mark - 播放原wav
- (void)playWav:(NSString *)filePath{
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    self.player = [[self player] initWithContentsOfURL:[NSURL URLWithString:self.recordFilePath] error:nil];
    [self.player play];
}

///删除文件
-(void)deleteFile:(NSString *)filePath{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL result = [fileManager removeItemAtPath:filePath error:nil];
    if (result) {
        SSLog(@"删除成功");
    }else{
        SSLog(@"删除失败:%@",filePath);
    }
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:directory error:nil];
    NSLog(@"dir:%@  - %@",directory,fileList);
}


- (NSMutableArray *)filePathsDataSource{
    if (!_filePathsDataSource) {
        _filePathsDataSource = [[NSMutableArray alloc] init];
    }
    return _filePathsDataSource;
}

- (NSMutableArray *)voiceTimeLengthArray{
    if (!_voiceTimeLengthArray) {
        _voiceTimeLengthArray = [[NSMutableArray alloc] init];
    }
    return _voiceTimeLengthArray;
}

- (UIView *)recordingView{
    if (!_recordingView) {
        _recordingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        _recordingView.center = _handerView.center;
        _recordingView.layer.cornerRadius = 5.0;
        _recordingView.backgroundColor = kColorAlpha(0, 0, 0, 0.3);
        
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 70, 70)];
        icon.image = [UIImage imageNamed:@"mic"];
        [_recordingView addSubview:icon];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150 - 10 - 30, 150, 30)];
        titleLabel.text = @"手指上滑，取消发送";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_recordingView addSubview:titleLabel];

        _recordingView.hidden = YES;
        
    }
    return _recordingView;
}

@end
