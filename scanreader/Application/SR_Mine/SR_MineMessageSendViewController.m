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
#import "UserInfo.h"
#import "httpTools.h"
#import "requestAPI.h"
#import "SR_MineMessageModel.h"
#import "AVRefreshExtension.h"
#import "SR_MineMessageFrameModel.h"
#import "SR_MineMessageSendDialogMineSendViewCell.h"
#import <SVProgressHUD.h>
#import "SR_FoundMainBookClubBookNoteListViewController.h"
#import "SR_BookClubBookModel.h"
#import "SR_InterPageDetailViewController.h"
#import "SR_InterPageListModel.h"
#import "SR_OthersMineViewController.h"
#import "SR_BookClubBookNoteModel.h"
#import "SR_MineMessageOpenUrlViewController.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>

@interface SR_MineMessageSendViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)UIView * toolBar;
@property(nonatomic,strong)UITextView * toolBarTextView;
@property(nonatomic,strong)UIButton * toolBarSendBtn;
@property(nonatomic,assign)NSInteger messageListPageIndex;
@property(nonatomic,assign)BOOL isFirstReq;
@property(nonatomic,assign)NSInteger longPressRow;
@end

@implementation SR_MineMessageSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self setupToolBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.isFirstReq = YES;
    self.messageListPageIndex = 0;
    [self addHeaderRefresh];
}

- (void)addHeaderRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

- (void)loadNewData{
    self.messageListPageIndex += 1;
    [self getDialogList];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SR_MineMessageFrameModel * frameModel = self.dataSource[indexPath.row];
    return frameModel.cellMessageLableSize.height + 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SR_MineMessageFrameModel * frameModel = self.dataSource[indexPath.row];
    if (frameModel.messageModel.isMyAccount) {
        NSString * cellId = @"SR_MineMessageSendDialogMineSendViewCell";
        SR_MineMessageSendDialogMineSendViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_MineMessageSendDialogMineSendViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.frameModel = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMyMessageCell:)];
        [cell addGestureRecognizer:recognizer];
        
        return cell;
    }else{//如果是创建的消息，就要区分跳转,当消息返回的内容包含了type这个字段才可以发生跳转
        NSString * cellId = @"SR_MineMessageSendDialogMineViewCell";
        SR_MineMessageSendDialogMineViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SR_MineMessageSendDialogMineViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        }
        cell.frameModel = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFriendMessageCell:)];
        [cell addGestureRecognizer:recognizer];
        
        return cell;
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action == @selector(copyMessage:) || action == @selector(deleteMessage:)) return YES;
    return NO;
}

- (void)longPressMyMessageCell:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        SR_MineMessageSendDialogMineViewCell *cell = (SR_MineMessageSendDialogMineViewCell *)recognizer.view;
        
        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
        self.longPressRow = indexPath.row;
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuVisible:NO animated:YES];
        
        [self becomeFirstResponder];
        UIMenuItem * copy = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyMessage:)];
        UIMenuItem * delete = [[UIMenuItem alloc] initWithTitle:@"撤回"action:@selector(deleteMessage:)];
    
        

        [menu setMenuItems:[NSArray arrayWithObjects:copy, delete, nil]];
        
        [menu setTargetRect:cell.frame inView:cell.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)longPressFriendMessageCell:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        SR_MineMessageSendDialogMineViewCell *cell = (SR_MineMessageSendDialogMineViewCell *)recognizer.view;
        
        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
        self.longPressRow = indexPath.row;
        
        [self becomeFirstResponder];
        UIMenuItem * copy = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyMessage:)];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        [menu setMenuItems:[NSArray arrayWithObjects:copy, nil]];
        
        [menu setTargetRect:cell.frame inView:cell.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)copyMessage:(id)item{
    NSString * content = [[self.dataSource[self.longPressRow] messageModel] content];
    [UIPasteboard generalPasteboard].string = content;
}

- (void)deleteMessage:(id)sender{
    [self deleteSessionMessagesWithRow:self.longPressRow];
}

- (void)deleteSessionMessagesWithRow:(NSInteger)row{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSString * messageId = [[self.dataSource[row] messageModel] message_id];
   
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken,@"id":@[messageId]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpTools post:DELETE_SESSION_MESSAGE_LIST andParameters:param success:^(NSDictionary *dic) {
        NSLog(@"delete message by id resutl:%@",dic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.dataSource removeObjectAtIndex:row];
        [self.tableView deleteRow:row inSection:0 withRowAnimation:(UITableViewRowAnimationFade)];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)getDialogList{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    
    NSString * page = [NSString stringWithFormat:@"%d",self.messageListPageIndex];
    
    NSDictionary * param = @{@"limit":[NSString stringWithFormat:@"%d",PAGE_NUM],@"page":page,@"user_id":userId,@"user_token":userToken,@"people_id":self.sender_id};
    
    [httpTools post:GET_DIALOG_MESSAGE_LIST andParameters:param success:^(NSDictionary *dic) {
        NSArray * list = dic[@"data"][@"list"];
        NSString * userId = [UserInfo getUserId];
        
        NSMutableArray * unsortList = [[NSMutableArray alloc] init];
        for (NSDictionary * item in list) {

            SR_MineMessageModel * messageModel = [SR_MineMessageModel modelWithDictionary:item];
            messageModel.message_id = item[@"id"];
            messageModel.sender.sender_id = item[@"sender"][@"id"];
            messageModel.recipient.recipient_id = item[@"recipient"][@"id"];
            messageModel.target.target_id = item[@"target"][@"id"];
            
            if ([messageModel.sender.sender_id isEqualToString:userId]) {
                messageModel.isMyAccount = YES;
            }else{
                messageModel.isMyAccount = NO;
            }
            
            [unsortList addObject:messageModel];
        }
        
        NSArray * sort = [unsortList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            SR_MineMessageModel * messageModel1 = (SR_MineMessageModel *)obj1;
            SR_MineMessageModel * messageModel2 = (SR_MineMessageModel *)obj2;
            NSNumber * num1 = @(messageModel1.time_create);
            NSNumber * num2  = @(messageModel2.time_create);
            NSComparisonResult result = [num2 compare:num1];
            return result == NSOrderedDescending;
        }];
        
        for (SR_MineMessageModel * messageModel in sort) {
            SR_MineMessageFrameModel * frameModel = [[SR_MineMessageFrameModel alloc] init];
            frameModel.messageModel = messageModel;
            [self.dataSource insertObject:frameModel atIndex:0];
        }
        self.messageListPageIndex = self.dataSource.count/PAGE_NUM + (self.dataSource.count%PAGE_NUM > 0 ? 1: 0);
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
        if (self.isFirstReq) {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
            self.isFirstReq = NO;
        }else{
            [self.tableView scrollToTop];
        }

    } failure:^(NSError *error) {
        
    }];
}
//返回值说明：
//type: url为跳转链接， app为客户端跳转对象（如打开互动页）
//
//只有对象才有下面数据
//target_type: book书籍， page互动页,  user用户
//target_id: 对象ID

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SR_MineMessageFrameModel * frameModel = self.dataSource[indexPath.row];
    NSLog(@"target_id:%@",frameModel.messageModel.target.target_id);
    ///判断target_type，APP
    if ([frameModel.messageModel.type isEqualToString:@"app"]) {//跳转到对象
        if ([frameModel.messageModel.target_type isEqualToString:@"book"]) {
            SR_FoundMainBookClubBookNoteListViewController * bookMarkListVC = [[SR_FoundMainBookClubBookNoteListViewController alloc] init];
            SR_BookClubBookModel * bookModel = [[SR_BookClubBookModel alloc] init];
            bookModel.book_id = frameModel.messageModel.target.target_id;
            bookMarkListVC.bookModel = bookModel;
            [self.navigationController pushViewController:bookMarkListVC animated:YES];
            
        }else if ([frameModel.messageModel.target_type isEqualToString:@"page"]) {
            
            SR_InterPageDetailViewController * pageDetailVC = [[SR_InterPageDetailViewController alloc] init];
            SR_InterPageListModel * pageListModel = [[SR_InterPageListModel alloc] init];
            pageListModel.pageId = frameModel.messageModel.target.target_id;
            pageDetailVC.pageListModel = pageListModel;
            [self.navigationController pushViewController:pageDetailVC animated:YES];
        }else if ([frameModel.messageModel.target_type isEqualToString:@"user"]) {
            SR_OthersMineViewController * otherVC = [[SR_OthersMineViewController alloc] init];
            SR_BookClubBookNoteModel * userModel = [[SR_BookClubBookNoteModel alloc] init];
            userModel.user.user_id = frameModel.messageModel.target.target_id;
            [self.navigationController pushViewController:otherVC animated:YES];
        }
    }else if ([frameModel.messageModel.type isEqualToString:@"url"]) {//跳转到互动页或者其他链接
        SR_MineMessageOpenUrlViewController * openUrlVC = [[SR_MineMessageOpenUrlViewController alloc] init];
        openUrlVC.url = frameModel.messageModel.url;
        [self.navigationController pushViewController:openUrlVC animated:YES];
    }
}

- (void)setupToolBar{
    self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 53, kScreenWidth, 53)];
    self.toolBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.toolBar];
    
    self.toolBarTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 8, kScreenWidth - 10 - 10 - 10 - 35, 35)];
    self.toolBarTextView.backgroundColor = [UIColor whiteColor];
    self.toolBarTextView.delegate = self;
    self.toolBarTextView.layer.cornerRadius = 5.0;
    self.toolBarTextView.font = [UIFont systemFontOfSize:15.0];
    [self.toolBar addSubview:self.toolBarTextView];
    
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
    if (!self.toolBarTextView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"输入内容不能为空"];
        return;
    }
    NSString * receipentId = [[[self.dataSource firstObject] messageModel] sender_id];
    [self sendMessage:receipentId content:self.toolBarTextView.text];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
//    UIMenuController * menu = [UIMenuController sharedMenuController];
//    [menu setMenuVisible:NO animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    UIMenuController *menu = [UIMenuController sharedMenuController];
//    [menu setMenuVisible:NO animated:NO];
}

- (void)setMessageModelsList:(NSArray *)messageModelsList{
    _messageModelsList = messageModelsList;
    NSArray * sort = [messageModelsList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        SR_MineMessageModel * messageModel1 = (SR_MineMessageModel *)obj1;
        SR_MineMessageModel * messageModel2 = (SR_MineMessageModel *)obj2;
        NSNumber * num1 = @(messageModel1.time_create);
        NSNumber * num2  = @(messageModel2.time_create);
        NSComparisonResult result = [num1 compare:num2];
        return result == NSOrderedDescending;
    }];
    
    for (SR_MineMessageModel * messageModel in sort) {
        SR_MineMessageFrameModel * frameModel = [[SR_MineMessageFrameModel alloc] init];
        frameModel.messageModel = messageModel;
        [self.dataSource addObject:frameModel];
    }
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
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:(self.dataSource.count - 1) inSection:0];
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

///发送消息
- (void)sendMessage:(NSString * )recipient_id content:(NSString *)content{
    NSString * userId = [UserInfo getUserId];
    NSString * userToken = [UserInfo getUserToken];
    NSDictionary * param = @{@"user_id":userId,@"user_token":userToken,@"recipient_id":recipient_id,
                             @"content":content};
    
    [httpTools post:SEND_MESSAGE andParameters:param success:^(NSDictionary *dic) {
       // NSLog(@"send message result:%@",dic);
        SR_MineMessageModel * newMessageModel = [[SR_MineMessageModel alloc] init];
        newMessageModel.content = self.toolBarTextView.text;
        newMessageModel.time_create = [[NSDate date] timeIntervalSince1970];
        Sender * sender = [[Sender alloc] init];
        sender.sender_id = [UserInfo getUserId];
        sender.avatar = [UserInfo getUserAvatar];
        sender.username = [UserInfo getUserName];
        newMessageModel.sender = sender;
        newMessageModel.isMyAccount = YES;
        
        self.toolBarTextView.text = @"";
        
        SR_MineMessageFrameModel * newFrameModel = [[SR_MineMessageFrameModel alloc] init];
        newFrameModel.messageModel = newMessageModel;
        [self.dataSource addObject:newFrameModel];
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation:(UITableViewRowAnimationBottom)];
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];

    } failure:^(NSError *error) {
        SSLog(@"error:%@",error);
    }];
}


@end
