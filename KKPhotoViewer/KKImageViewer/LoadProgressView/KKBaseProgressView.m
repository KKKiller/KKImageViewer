//
//  KKBaseProgressView.m
//  KKProgressView
//
//  Created by 周吾昆 on 15/10/8.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import "KKBaseProgressView.h"

@implementation KKBaseProgressView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KKProgressViewBackgroundColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    if(progress <= 0){
        progress = 0.1;
    }
    if (progress >= 1.0) {
//        [self removeFromSuperview];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    }
    
}

- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes
{
    CGFloat xCenter = self.frame.size.width * 0.5;
    CGFloat yCenter = self.frame.size.height * 0.5;
    
    // 判断系统版本
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        CGSize strSize = [text sizeWithAttributes:attributes];
        CGFloat strX = xCenter - strSize.width * 0.5;
        CGFloat strY = yCenter - strSize.height * 0.5;
        [text drawAtPoint:CGPointMake(strX, strY) withAttributes:attributes];
    } else {
        CGSize strSize;
        NSAttributedString *attrStr = nil;
        if (attributes[NSFontAttributeName]) {
            strSize = [text sizeWithAttributes:attributes[NSFontAttributeName]];
//            strSize = [text sizeWithFont:attributes[NSFontAttributeName]];
            attrStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        } else {
            strSize = [text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]}];
//            strSize = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
            attrStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]}];
        }
        
        CGFloat strX = xCenter - strSize.width * 0.5;
        CGFloat strY = yCenter - strSize.height * 0.5;
        
        [attrStr drawAtPoint:CGPointMake(strX, strY)];
    }
    
    
    
}

// 清除指示器
- (void)dismiss
{
    self.progress = 1.0;
}

+ (id)progressView
{
    return [[self alloc] init];
}

@end
