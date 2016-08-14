//
//  httpTools.m
//  scanreader
//
//  Created by jbmac01 on 16/8/9.
//  Copyright © 2016年 jb. All rights reserved.
//

#import "httpTools.h"
#import <AFNetworking.h>
#import "globalHeader.h"
#import "Tools.h"
#import <SVProgressHUD.h>
@implementation httpTools

+ (void)post:(NSString *)url
      andParameters:(NSDictionary *)parameters
            success:(void (^)(NSDictionary *dic))success
            failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    
    NSString * timeStmp = TIME_STAMP;
    NSString * nonce = [Tools getRadomCode:6];
    NSString * toHash = [NSString stringWithFormat:@"%@%@%@%@",CLIENT_SECRET,timeStmp,nonce,url];
  //  NSLog(@"加密前签名:%@",toHash);
    NSString * res = [Tools hmac:toHash withKey:CLIENT_SECRET];
  //  NSLog(@"加密后签名:%@",res);
    
    NSData *resData = [res dataUsingEncoding:NSUTF8StringEncoding];
    NSString * signature = [resData base64EncodedStringWithOptions:0];
 //   NSLog(@"base64签名:%@,length:%d",signature,signature.length);
//    signature = [Tools appendEqualSign:signature];
//    NSLog(@"new signature:%@,new length:%d",signature,signature.length);
    NSDictionary * baseParams = @{@"client_id":CLIENT_ID,@"sign":signature,@"timestamp":timeStmp,
                                  @"nonce":nonce};
    NSMutableDictionary * requestParam = [[NSMutableDictionary alloc] init];
    [requestParam addEntriesFromDictionary:baseParams];
    [requestParam addEntriesFromDictionary:parameters];
   // NSLog(@"请求参数:%@",requestParam);

    
    [sessionManager POST:url parameters:requestParam progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            success(responseObject);
        }else{
            [SVProgressHUD showInfoWithStatus:@"msg"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // SSLog(@"error:%@",error);
        failure(error);
    }];
}

+ (void)get:(NSString *)url
      andParameters:(NSDictionary *)parameters
            success:(void (^)(NSDictionary *dic))success
            failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"res:%@",responseObject);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@",error);  //这里打印错误信息
    }];
}

@end
