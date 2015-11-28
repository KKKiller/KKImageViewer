//
//  KKViewController.m
//  KKPhotoViewer
//
//  Created by 周吾昆 on 15/11/27.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import "KKViewController.h"
#import "KKTapImageView.h"
#import "KKImageViewerHelper.h"
#define IMAGECOUNT 4 //图片张数
#define IMAGESIZE 80 //图片尺寸
@interface KKViewController()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *collectionView;
@end
@implementation KKViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return IMAGECOUNT;
}
//设置评论图片
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    KKTapImageView *imgView = [[KKTapImageView alloc]initWithFrame:CGRectMake(0, 0, IMAGESIZE, IMAGESIZE)];
    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd",indexPath.item]];
    imgView.tag = 100;
    imgView.currentIndex = indexPath.row; //为每个cell里的子控件imgView做标记
    imgView.userInteractionEnabled = NO;
    [cell.contentView addSubview:imgView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    KKImageViewerHelper *helper = [[KKImageViewerHelper alloc]init];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    KKTapImageView *imgView = (KKTapImageView *)[cell.contentView viewWithTag:100];
    [helper tappedAtImgView:imgView collectionView:collectionView imgCount:IMAGECOUNT];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(IMAGESIZE, IMAGESIZE);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 200, IMAGESIZE*IMAGECOUNT + (IMAGECOUNT-1)*10 ,200) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor purpleColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    }
    return _collectionView;
}
@end
