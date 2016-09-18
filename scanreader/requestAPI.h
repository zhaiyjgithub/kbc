//
//  requestAPI.h
//  scanreader
//
//  Created by jbmac01 on 16/8/14.
//  Copyright © 2016年 jb. All rights reserved.
//

#ifndef requestAPI_h
#define requestAPI_h

#define PAGE_NUM 100

#define SEARCH_TYPE_NOTE 1
#define SEARCH_TYPE_INTER_PAGE 2
#define SEARCH_TYPE_SCAN 3

#define NOTE_TYPE_TEXT @"1"
#define NOTE_TYPE_PIX @"2"
#define NOTE_TYPE_VOICE @"3"
#define NOTE_TYPE_COLLECTION @"4"

#define NOTE_MODE_COLLECTION_AND_NOTE @"1"
#define NOTE_MODE_NOTE @"2"
#define NOTE_MODE_COLLECTION @"3"

#define PAGE_TYPY_1 @"1"
#define PAGE_TYPY_2 @"2"
#define PAGE_TYPY_3 @"3"
#define PAGE_TYPY_4 @"4"
#define PAGE_TYPY_5 @"5"
#define PAGE_TYPY_6 @"6"
#define PAGE_TYPY_7 @"7"
#define PAGE_TYPY_8 @"8"
#define PAGE_TYPY_9 @"9"

#define NOTE_REQUSERT_TYPE_SAVE  @"1"
#define NOTE_REQUSERT_TYPE_UPDATE @"2"
#define NOTE_REQUSERT_TYPE_SAVE_PAGE  @"3"

#define USER_ID [UserInfo getUserUserId]
#define TOKEN [UserInfo getUserToken]

#define REGISTER     @"/api/user/register"
#define LOGIN        @"/api/user/login"
#define LOGIN_OUT    @"/api/user/logout"
#define GET_NOTE_LIST_ALL @"/api/note/getList"

#define CREATE_BOOK_CLUB @"/api/book/save"
#define GET_BOOK_CLUB_LIST_ALL @"/api/book/getList"
#define SAVE_NOTE  @"/api/note/save"

#define GET_PAGE_LIST @"/api/page/getList"
#define GET_MESSAGE_LIST @"/api/message/getList"
#define GET_MESSAGE_ONE_ITEM @"/api/message/getOne"
#define SEND_MESSAGE @"/api/message/save"

#define UPDATE_USER_INFO @"/api/user/update"
#define GET_USER_INFO @"/api/user/getOne"
#define GET_PAGE_ONE_ITEM @"/api/page/getOne"
#define DELETE_REOURCE @"/api/note/deleteResource"

#define UPDATE_NOTE @"/api/note/update"
#define GET_NOTE_ONE @"/api/note/getOne"
#define DELETE_SESSION_MESSAGE_LIST @"/api/message/delete"
#define CLEAR_ALL_MESSAGE @"/api/message/deleteAll"

#define FIND_PASSOWRD @"/api/user/findPassword"

#endif /* requestAPI_h */
