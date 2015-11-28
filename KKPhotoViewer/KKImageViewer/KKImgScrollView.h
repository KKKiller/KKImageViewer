//
//  ImgScrollView.h
//  TestLayerImage
//
//  Created by 周吾昆 on 15/10/8.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPieProgressView.h"
#import "KKLoadingProgressView.h"
#import "KKPercentProgressView.h"

@interface KKImgScrollView : UIScrollView

- (void) setContentWithFrame:(CGRect) rect;
- (void) setImage:(UIImage *)images url:(NSURL *)url;
- (void) setAnimationRect;
- (void) rechangeInitRdct;

@property(nonatomic, strong) NSURL *url;
@property(nonatomic, assign) BOOL isChangeFrame;
@property(nonatomic, strong) KKPercentProgressView *progressView;
//@property(nonatomic, strong) KKLoadingProgressView *progressView;
//@property(nonatomic, strong) KKPieProgressView *progressView;

@end
