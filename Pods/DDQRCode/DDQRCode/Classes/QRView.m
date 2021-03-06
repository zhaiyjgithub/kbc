//
//  QRView.m
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "QRView.h"
#import "QRUtil.h"

static NSTimeInterval kQrLineanimateDuration = 0.02;

@implementation QRView {

        UIImageView *qrLine;
        CGFloat qrLineY;
        QRMenu *qrMenu;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self initQRLine];
    
    CGSize screenSize =[QRUtil screenBounds].size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
                                      screenDrawRect.size.height / 2 - self.transparentArea.height / 2,
                                      self.transparentArea.width,self.transparentArea.height);

    UILabel * tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, clearDrawRect.origin.y + clearDrawRect.size.height + 10, [UIScreen mainScreen].bounds.size.width, 16)];
    tipsLabel.text = @"将图形放进框内，即可自动扫描";
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:14.0];
    tipsLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:tipsLabel];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 动画选项的设定
    animation.duration = 1.0; // 持续时间
    animation.repeatCount = HUGE_VAL; // 重复次数
    
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2.0, clearDrawRect.origin.y + 1)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2.0, clearDrawRect.origin.y + 260 - 1)]; // 终了帧
    
    // 添加动画
    [qrLine.layer addAnimation:animation forKey:@"move-layer"];
}

- (void)initQRLine {
    CGRect screenBounds = [QRUtil screenBounds];
    qrLine  = [[UIImageView alloc] initWithFrame:CGRectMake(screenBounds.size.width / 2 - self.transparentArea.width / 2, screenBounds.size.height / 2 - self.transparentArea.height / 2, self.transparentArea.width, 2)];
    qrLine.image = [UIImage imageNamed:@"qr_scan_line"];
    qrLine.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:qrLine];
    qrLineY = qrLine.frame.origin.y;
}

- (void)initQrMenu {
    
    CGFloat height = 100;
    CGFloat width = [QRUtil screenBounds].size.width;
    qrMenu = [[QRMenu alloc] initWithFrame:CGRectMake(0, [QRUtil screenBounds].size.height - height, width, height)];
    qrMenu.backgroundColor = [UIColor grayColor];
    [self addSubview:qrMenu];
    
    __weak typeof(self)weakSelf = self;

    qrMenu.didSelectedBlock = ^(QRItem *item){
        
        NSLog(@"点击的是%lu",(unsigned long)item.type);
        
        if ([weakSelf.delegate respondsToSelector:@selector(scanTypeConfig:)] ) {
            
            [weakSelf.delegate scanTypeConfig:item];
        }
    };
}

- (void)show {
    
    /* 移动 */
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//    
//    // 动画选项的设定
//    animation.duration = 1.0; // 持续时间
//    animation.repeatCount = HUGE_VAL; // 重复次数
//    
//    // 起始帧和终了帧的设定
//    animation.fromValue = [NSValue valueWithCGPoint:qrLine.layer.position]; // 起始帧
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2.0, 1)];
//    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height - 1)]; // 终了帧
//    
//    // 添加动画
//    [qrLine.layer addAnimation:animation forKey:@"move-layer"];
    
//    [UIView animateWithDuration:kQrLineanimateDuration animations:^{
//        
//        CGRect rect = qrLine.frame;
//        rect.origin.y = qrLineY;
//        qrLine.frame = rect;
//        
//    } completion:^(BOOL finished) {
//        
//        CGFloat maxBorder = self.frame.size.height / 2 + self.transparentArea.height / 2 - 4;
//        if (qrLineY > maxBorder) {
//            
//            qrLineY = self.frame.size.height / 2 - self.transparentArea.height /2;
//        }
//        qrLineY++;
//    }];
}

- (void)drawRect:(CGRect)rect {
    
    //整个二维码扫描界面的颜色
    CGSize screenSize =[QRUtil screenBounds].size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
                                      screenDrawRect.size.height / 2 - self.transparentArea.height / 2,
                                      self.transparentArea.width,self.transparentArea.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self addScreenFillRect:ctx rect:screenDrawRect];
    
    [self addCenterClearRect:ctx rect:clearDrawRect];
    
    [self addWhiteRect:ctx rect:clearDrawRect];
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
    
    
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    //kColor(0x43,0xdf,0xd9)
    CGContextSetRGBStrokeColor(ctx, (0x43) /255.0, (0xdf)/255.0, (0xd9)/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}


@end
