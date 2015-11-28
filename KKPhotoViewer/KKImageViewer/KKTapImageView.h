//
//  TapImageView.h
//  TestLayerImage
//
//  Created by 周吾昆 on 15/10/8.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKImageViewerHelper;
@protocol TapImageViewDelegate <NSObject>

- (void) tappedWithObject:(id) sender;

@end

@interface KKTapImageView : UIImageView

@property (weak) id<TapImageViewDelegate> t_delegate;

@property(nonatomic, strong) UIButton *tapView;

@property(nonatomic, strong) KKImageViewerHelper *helper;

@property(nonatomic, assign) NSInteger currentRow; //当前图片在tableView中的所在行
@property(nonatomic, assign) NSInteger currentIndex; //当前图片在collectionView中所在位置

@property(nonatomic, strong) NSURL *url;
@end
