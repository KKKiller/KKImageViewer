//
//  VIewerHelper.m
//  图片浏览器-tableView
//
//  Created by 周吾昆 on 15/10/8.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import "KKImageViewerHelper.h"
#import "KKImgScrollView.h"
#import "KKTapImageView.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UIImage+Circle.h"

static NSInteger imgGap = 20; //放大图片间黑色间距
@interface KKImageViewerHelper()<TapImageViewDelegate,UIScrollViewDelegate>
//浏览器的scrollView
@property(nonatomic, strong) UIScrollView *myScrollView;
//当前位置索引
@property(nonatomic, assign) NSInteger currentIndex;
//容器视图
@property(nonatomic, strong) UIView *scrollPanel;
@property(nonatomic, strong) UIView *markView;
@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) NSInteger imgCount;
@end

@implementation KKImageViewerHelper

- (void)tappedAtImgview:(KKTapImageView *)tapImageView{
    if (!self.isHeadImg) {//头像不需要走一下方法
        UITableView *tableView = [self.delegate getTableView];
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:tapImageView.currentRow - 10 inSection:0];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexP]; //得到tableView中点击图片所在的cell
        self.collectionView = (UICollectionView *)[cell viewWithTag:tapImageView.currentRow]; //得到tableView中点击图片所在的collectionView
        for (UIView *v in self.collectionView.subviews) {
            if ([v isKindOfClass:[UICollectionViewCell class]]) {
                self.imgCount++;
            }
        }
    }
    [self addScrollView];
    tapImageView.t_delegate = self;
    [self tappedWithObject:tapImageView];
}

- (void)tappedAtImgView:(KKTapImageView *)tapImgView collectionView:(UICollectionView *)collectionView imgCount:(NSInteger)imgCount{
    self.collectionView = collectionView;
    self.imgCount = imgCount;
    [self addScrollView];
    tapImgView.t_delegate = self;
    [self tappedWithObject:tapImgView];
}

- (void)addScrollView{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.window = appdelegate.window;
    [self addSubView];
}

- (void)addSubView{
    //容器,装背景图与scrollView
    self.scrollPanel = [[UIView alloc] initWithFrame:self.window.bounds];
    self.self.scrollPanel.backgroundColor = [UIColor clearColor];
    self.scrollPanel.alpha = 0;
    self.scrollPanel.tag = 1000;
    [self.window addSubview:self.scrollPanel];
    [self.window bringSubviewToFront:self.scrollPanel];
    
    self.markView = [[UIView alloc] initWithFrame:self.window.bounds];
    self.markView.backgroundColor = [UIColor blackColor];
    self.markView.alpha = 0.0;
    [self.scrollPanel addSubview:self.markView];
    self.markView.tag = 101;
    
    self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width + imgGap, self.window.frame.size.height)];
    [self.scrollPanel addSubview:self.myScrollView];
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.delegate = self;
    CGSize contentSize = self.myScrollView.contentSize;
    contentSize.height = self.window.bounds.size.height;
    contentSize.width = (self.window.frame.size.width + imgGap) * self.imgCount;
    self.myScrollView.contentSize = contentSize;
    self.myScrollView.backgroundColor = [UIColor clearColor];
}



//点击小图,实现小图放大 代理方法
- (void) tappedWithObject:(id)sender
{
    [self.window bringSubviewToFront:self.scrollPanel];
    self.scrollPanel.alpha = 1.0;
    
    KKTapImageView *tmpView = sender;
    self.currentIndex = tmpView.currentIndex ;
    
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.window];
    
    CGPoint contentOffset = self.myScrollView.contentOffset;
    contentOffset.x = self.currentIndex * (self.window.frame.size.width + imgGap);
    self.myScrollView.contentOffset = contentOffset;
    
    //添加放大后的图片
    [self addSubImgView];
    
    KKImgScrollView *tmpImgScrollView = [[KKImgScrollView alloc] initWithFrame:(CGRect){contentOffset,self.window.bounds.size.width,self.myScrollView.bounds.size.height}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    if (self.isHeadImg) {
        tmpView.image = [UIImage circleImage:tmpView.image];
    }
    [tmpImgScrollView setImage:tmpView.image url:tmpView.url];
    [self.myScrollView addSubview:tmpImgScrollView];
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}
//设置大图位置
- (void) setOriginFrame:(KKImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        self.markView.alpha = 1.0;
        NSLog(@"%@",self.markView);
    }];
}
//进入大图界面,添加大图
- (void) addSubImgView
{
    for (UIView *tmpView in self.myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i < self.imgCount; i ++)
    {
        if (i == self.currentIndex)
        {
            continue;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        KKTapImageView *tmpView = cell.contentView.subviews.lastObject;
        tmpView.t_delegate = self;
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.window];
        //大图的位置
        KKImgScrollView *tmpImgScrollView = [[KKImgScrollView alloc] initWithFrame:(CGRect){i*self.myScrollView.bounds.size.width,0,self.window.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image url:tmpView.url];
        [self.myScrollView addSubview:tmpImgScrollView];
        [tmpImgScrollView setAnimationRect];
    }
}


//点击放大后的图片,将大图关闭
- (void) tapImageViewTappedWithObject:(id)sender
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UIWindow *window = appdelegate.window;
    
    KKImgScrollView *tmpImgView = sender;
    
    [MBProgressHUD hideAllHUDsForView:tmpImgView animated:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView  *v in window.subviews) {
            if (v.tag == 1000) {
                for (UIView *vv in v.subviews) {
                    if (vv.tag == 101) {
                        vv.backgroundColor = [UIColor clearColor];
                    }
                }
            }
        }
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        for (UIView  *v in window.subviews) {
            if (v.tag == 1000) {
                v.alpha = 0.0;
            }
        }
    }];
    
}

#pragma mark - scroll delegate
//scrollView代理方法
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    self.currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}
@end
