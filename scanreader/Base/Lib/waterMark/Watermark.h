//
//  Watermark.h
//  Scanner
//
//  Created by 戴尼玛 on 16/7/19.
//  Copyright © 2016年 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Watermark : NSObject
+(void)recognitionWithImage:(UIImage *)aImage result:(void(^)(BOOL, NSString*))aResultBlock;
+(UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
@end
