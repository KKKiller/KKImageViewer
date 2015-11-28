//
//  ImgScrollView.m
//  TestLayerImage
//
//  Created by 周吾昆 on 15/10/8.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import "KKImgScrollView.h"
#import "KKImageViewerHelper.h"
#import "SDWebImageManager.h"
#import "KKPieProgressView.h"
#import "KKLoadingProgressView.h"
#import "KKPercentProgressView.h"
#import "MBProgressHUD.h"

@interface KKImgScrollView()<UIScrollViewDelegate>
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, assign) CGRect scaleOriginRect; //记录自己的位置
@property(nonatomic, assign) CGSize imgSize; //图片的大小
@property(nonatomic, assign) CGRect initRect; //缩放前大小
@end

@implementation KKImgScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        
        self.imgView = [[UIImageView alloc] init];
        self.imgView.clipsToBounds = YES;
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imgView];

    }
    return self;
}

- (void) setContentWithFrame:(CGRect) rect
{
    _imgView.frame = rect;
    _initRect = rect;
}

- (void) setAnimationRect
{
    _imgView.frame = self.scaleOriginRect;
}

- (void) rechangeInitRdct
{
    self.zoomScale = 1.0;
    self.imgView.frame = self.initRect;
}

- (void) setImage:(UIImage *)images url:(NSURL *)url
{
    if (images)
    {
        _imgView.image = images;
        [self setImageMargin:images];
        
        if (url) {
//            KKPieProgressView *progressView = [[KKPieProgressView alloc]init];
            KKPercentProgressView *progressView = [[KKPercentProgressView alloc]init];
//            KKLoadingProgressView *progressView = [[KKLoadingProgressView alloc]init];
            progressView.frame = CGRectMake((375 - 100) * 0.5, (663 - 100) * 0.5, 100, 100);
            self.progressView = progressView;
            self.progressView.alpha = 0.5;
            progressView.alpha = 0.0;
            [self addSubview:progressView];
            [self performSelector:@selector(progressViewAppear) withObject:self afterDelay:0.3];
            
            [[SDWebImageManager sharedManager]downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                progressView.progress = (float)receivedSize / (float)expectedSize;
                NSLog(@"已下载 %.1f %%",progressView.progress * 100);
                if (progressView.progress >= 1.0) {
                    self.progressView.hidden = YES;
                    self.isChangeFrame = YES;
                }
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                self.progressView.hidden = YES;
                if (!image) {
                    [self performSelector:@selector(showLoadFailView) withObject:nil afterDelay:0.3];
                    return ;
                }
                self.imgView.image = image;
                [self setImageMargin:image];
                if (self.isChangeFrame) {
                    [self setAnimationRect];
                    self.isChangeFrame = NO;
                }
            }];
        }
        
    }
}
- (void)showLoadFailView{
    [MBProgressHUD showMessage:@"图片加载失败" onView:self duration:2 alpha:0.5];
}

- (void)progressViewAppear{
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)setImageMargin:(UIImage *)image{
    self.imgSize = image.size;
    //判断首先缩放的值
    float scaleX = self.frame.size.width/self.imgSize.width ;
    float scaleY = self.frame.size.height/self.imgSize.height;
    
    //倍数小的，先到边缘
    
    if (scaleX > scaleY)
    {
        //Y方向先到边缘
        float imgViewWidth = self.imgSize.width*scaleY;
        self.maximumZoomScale = self.frame.size.width/imgViewWidth + 2;
        
        self.scaleOriginRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
    }
    else
    {
        //X先到边缘
        float imgViewHeight = self.imgSize.height*scaleX;
        self.maximumZoomScale = self.frame.size.height/imgViewHeight + 2;
        
        self.scaleOriginRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
    }
}
#pragma mark - scroll delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = self.imgView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }
    
    self.imgView.center = centerPoint;
}

#pragma mark - touch
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.alpha = 0.0;
    }];
    KKImageViewerHelper *vc = [[KKImageViewerHelper alloc]init];
    [vc tapImageViewTappedWithObject:self];
}

@end
