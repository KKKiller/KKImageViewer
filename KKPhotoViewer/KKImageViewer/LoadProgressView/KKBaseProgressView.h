//
//  KKBaseProgressView.h
//  KKProgressView
//
//  Created by 周吾昆 on 15/10/8.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KKColorMaker(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define KKProgressViewItemMargin 10

#define KKProgressViewFontScale (MIN(self.frame.size.width, self.frame.size.height) / 100.0)

// 背景颜色
#define KKProgressViewBackgroundColor KKColorMaker(240, 240, 240, 0.9)

@interface KKBaseProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes;

- (void)dismiss;

+ (id)progressView;

@end
