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
#import "SR_LoginViewController.h"
@implementation httpTools

+ (void)post:(NSString *)url
      andParameters:(NSDictionary *)parameters
            success:(void (^)(NSDictionary *dic))success
            failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
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
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if (([responseObject[@"status"] intValue]) > 0) {
                success(responseObject);
            }else if ([responseObject[@"status"] isEqualToString:@"-111"]){//你的账号已在其他地方登陆，请重新登陆
                [UIApplication sharedApplication].keyWindow.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController = [[SR_LoginViewController alloc] init];
                [SVProgressHUD showInfoWithStatus:@"你的账号已在其他地方登录，请重新登录"];
            }else{
                [SVProgressHUD showInfoWithStatus:responseObject[@"msg"]];
                success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SSLog(@"error:%@",error);
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

///上传多张图片
+ (void)uploadImage:(NSString *)url parameters:(NSDictionary *)parameters images:(NSArray *)images
            success:(void (^)(NSDictionary *dic))success
            failure:(void (^)(NSError *error))failure{
    
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
    
    NSString * requestUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrl parameters:requestParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传 多张图片
        for (int i = 0; i < images.count; i ++) {
            NSString *fileName = [NSString stringWithFormat:@"%@%02d.%@",@"file",i,@"jpg"];
            NSData * imageData = UIImageJPEGRepresentation(images[i], 0.5);
            [formData appendPartWithFileData:imageData name:@"file[]" fileName:fileName mimeType:@"image/jpeg"];
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
//                          [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"上传中"];
//                          NSLog(@"%f",uploadProgress.fractionCompleted);
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          failure(error);
//                          [SVProgressHUD dismiss];
                      } else {
//                          [SVProgressHUD dismiss];
                          if([responseObject isKindOfClass:[NSDictionary class]]){
                              if ([responseObject[@"status"] intValue]) {
                                  success(responseObject);
                              }else{
                                  [SVProgressHUD showInfoWithStatus:responseObject[@"msg"]];
                              }
                          }
                      }
                  }];
    
    [uploadTask resume];
}




@end
