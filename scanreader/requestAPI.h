//
//  requestAPI.h
//  scanreader
//
//  Created by jbmac01 on 16/8/14.
//  Copyright © 2016年 jb. All rights reserved.
//

#ifndef requestAPI_h
#define requestAPI_h

#define PAGE_NUM 70

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

#define USER_ID [UserInfo getUserUserId]
#define TOKEN [UserInfo getUserToken]

#define REGISTER     @"/api/user/register"
#define LOGIN        @"/api/user/login"
#define LOGIN_OUT    @"/api/user/logout"
#define GET_LIST_ALL @"/api/note/getList"

#define CREATE_BOOK_CLUB @"/api/book/save"
#define GET_BOOK_CLUB_LIST_ALL @"/api/book/getList"
#define SAVE_NOTE  @"/api/note/save"

#endif /* requestAPI_h */
