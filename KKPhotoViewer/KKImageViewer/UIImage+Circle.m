//
//  UIImage+vImage.m
//  HotFitness
//
//  Created by zhang_rongwu on 15/10/31.
//  Copyright © 2015年 HeGuangTongChen. All rights reserved.
//

#import "UIImage+Circle.h"
@implementation UIImage (Circle)
//把图片进行裁剪
+ (UIImage*)circleImage:(UIImage*)image{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.1);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
@end
