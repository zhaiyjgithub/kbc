//
//  SR_MineMessageSendViewController.m
//  scanreader
//
//  Created by jbmac01 on 16/7/19.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "SR_MineMessageSendViewController.h"
#import "globalHeader.h"
#import "SR_MineMessageSendDialogMineViewCell.h"

@interface SR_MineMessageSendViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)UIView * toolBar;
@property(nonatomic,strong)UITextField * toolBarTextField;
@property(nonatomic,strong)UIButton * toolBarSendBtn;

@property(nonatomic,assign)NSInteger numOfRows;
@end

@implementation SR_MineMessageSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户名称";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.numOfRows = 10;
    [self setupToolBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.numOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"SR_MineMessageSendDialogMineViewCell";
    SR_MineMessageSendDialogMineViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SR_MineMessageSendDialogMineViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setupToolBar{
    self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 53, kScreenWidth, 53)];
    self.toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.toolBar];
    
    self.toolBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 8, kScreenWidth - 10 - 10 - 10 - 35, 35)];
    self.toolBarTextField.backgroundColor = [UIColor whiteColor];
    self.toolBarTextField.delegate = self;
    [self.toolBar addSubview:self.toolBarTextField];
    
    self.toolBarSendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.toolBarSendBtn.frame = CGRectMake(kScreenWidth - 10 - 44, 8, 44, 35);
    [self.toolBarSendBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    [self.toolBarSendBtn setTitleColor:baseColor forState:(UIControlStateNormal)];
    [self.toolBarSendBtn setTitle:@"发送" forState:(UIControlStateHighlighted)];
    [self.toolBarSendBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    [self.toolBarSendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.toolBar addSubview:self.toolBarSendBtn];
}

- (void)clickSendBtn{
    SSLog(@"send btn");
    self.numOfRows+=1;
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:self.numOfRows-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:(UITableViewRowAnimationBottom)];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
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
        self.toolBar.frame = CGRectMake(0, kScreenHeight - keyBoardRect.size.height - 53, kScreenWidth, 53);
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - keyBoardRect.size.height - 53);
    } completion:^(BOOL finished) {
        if (finished) {
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:(self.numOfRows-1) inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.toolBar.frame = CGRectMake(0, kScreenHeight - 53, kScreenWidth, 53);
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 53);
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
}

#pragma mark -UI控件
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 53) style:UITableViewStylePlain];
        //当前使用原生的分割线，不适用图片的方式加载分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tintColor=[UIColor orangeColor];
        
        _tableView=tableView;
    }
    return _tableView;
}
#pragma mark -数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _dataSource;
}



@end
