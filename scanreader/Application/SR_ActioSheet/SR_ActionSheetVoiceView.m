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
    
    UIView * voiceView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height + 5, kScreenWidth, sizeHeight(30 + 54))];
    voiceView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:voiceView];
    
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(0, 0, 70, 70);
    btn.center = CGPointMake(kScreenWidth/2, 47);
    btn.backgroundColor = baseColor;
    btn.layer.cornerRadius = 35.0;
    [btn setTitle:@"按住" forState:(UIControlStateNormal)];
    [btn setTitleColor:baseblackColor forState:(UIControlStateNormal)];
    [btn setTitle:@"松开" forState:(UIControlStateHighlighted)];
    [btn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [btn addTarget:self action:@selector(clickVoice) forControlEvents:(UIControlEventTouchUpInside)];
    [btn addTarget:self action:@selector(touchdown) forControlEvents:(UIControlEventTouchDown)];
    self.voiceBtn = btn;
    [voiceView addSubview:btn];
    
    UIButton * sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sendBtn.frame = CGRectMake(kScreenWidth - 12 - 44, 10, 44, 44);
    [sendBtn setTitle:@"发布" forState:(UIControlStateNormal)];
    [sendBtn setTitleColor:baseblackColor forState:(UIControlStateNormal)];
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
    
//    for (NSString * filePath in self.filePathsDataSource) {
//        SSLog(@"for-in file path:%@",filePath);
//    }
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    sendBtn.enabled = NO;
    
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken,@"type":NOTE_TYPE_VOICE,
                             @"title":self.titleTextField.text};
    [MBProgressHUD showHUDAddedTo:self.handerView animated:YES];
    [httpTools uploadVoice:SAVE_NOTE parameters:param voicesUrl:self.filePathsDataSource success:^(NSDictionary *dic) {
        [sendBtn setTitleColor:baseblackColor forState:(UIControlStateNormal)];
        sendBtn.enabled = YES;
        [MBProgressHUD hideHUDForView:self.handerView animated:YES];
        [SVProgressHUD showSuccessWithStatus:@"笔记创建成功"];
        for (NSString * filePath in self.filePathsDataSource) {
            [self deleteFile:filePath];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    } failure:^(NSError *error) {
        [sendBtn setTitleColor:baseblackColor forState:(UIControlStateNormal)];
        sendBtn.enabled = YES;
        [SVProgressHUD showErrorWithStatus:@"笔记创建失败"];
        [MBProgressHUD hideHUDForView:self.handerView animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });

    }];
}

///录制最多1min
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:59 target:self selector:@selector(timeout) userInfo:nil repeats:YES];
}

- (void)removeTimer{
    [self.timer invalidate];
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

///松手
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
    [self addTimer];
    SSLog(@"touch down");
    [self beginRecord];
}

///录音完成
- (void)stopRecord{
    if (self.recorder.isRecording){//录音中
        //停止录音
        [self.recorder stop];
        NSLog(@"停止录音");
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
    __weak typeof(self) weakSelf = self;
    [cell addBlock:^(UIButton *btn) {
        if (btn.tag == 0) {
            SSLog(@"play");
            [weakSelf playVoiceWithFilePath:weakSelf.filePathsDataSource[indexPath.row]];
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

- (void)playVoiceWithFilePath:(NSString *)filePath {
    SSLog(@"begin to play path:%@",filePath);
    NSURL * url = [NSURL fileURLWithPath:filePath];
    self.remotePlayer = [[AVPlayer alloc] initWithURL:url];
    [self.remotePlayer play];
}

- (void)showDeleteAlertViewWithRow:(NSInteger)row{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"要删除这条语音笔记吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = row;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        //删除本地
        [self deleteFile:self.filePathsDataSource[alertView.tag]];
        [self.filePathsDataSource removeObjectAtIndex:alertView.tag];
        [self.tableView reloadData];
    }
}

- (void)show{
    self.handerView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _handerView.frame = [UIScreen mainScreen].bounds;
    _handerView.backgroundColor = [UIColor clearColor];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    [_handerView addSubview:self];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    
    [UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _handerView.backgroundColor = kColorAlpha(0, 0, 0, 0.20);
        self.frame = CGRectMake(0, kScreenHeight - sizeHeight(400), kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
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



@end
