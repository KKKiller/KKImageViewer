//
//  VIewerHelper.h
//  图片浏览器-tableView
//
//  Created by 周吾昆 on 15/10/8.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKTapImageView.h"
@protocol KKImageViewerHelperDelegate <NSObject>
- (UITableView *)getTableView;
@end

@interface KKImageViewerHelper : NSObject
@property(nonatomic, weak) id<KKImageViewerHelperDelegate> delegate;

- (void)tapImageViewTappedWithObject:(id)sender;

//在一个tableView中的每个Cell都有多张图片
- (void)tappedAtImgview:(KKTapImageView *)tapImageView;

//一个collectionView,每个cell是放一张图片,用此方法
- (void)tappedAtImgView:(KKTapImageView *)tapImgView collectionView:(UICollectionView *)collectionView imgCount:(NSInteger)imgCount;

//如果是单张图片,图片放大时做切圆处理,如果是多张图片,不做处理,适用于圆形头像
@property(nonatomic, assign) BOOL isHeadImg;

@end
