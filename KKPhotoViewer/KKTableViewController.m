//
//  KKTableViewController.m
//  KKPhotoViewer
//
//  Created by 周吾昆 on 15/11/27.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import "KKTableViewController.h"
#import "KKTapImageView.h"
#import "KKImageViewerHelper.h"
#import "UIImageView+WebCache.h"

#define IMAGECOUNT 4
#define IMAGESIZE 80
@interface KKTableViewController()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,KKImageViewerHelperDelegate>
@property(nonatomic, strong) UICollectionView *collectionView;
@end

@implementation KKTableViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.rowHeight = 100;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(IMAGESIZE, IMAGESIZE);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, 10, IMAGESIZE * 4 + (IMAGECOUNT-1)*10, IMAGESIZE) collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [cell addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.tag = indexPath.row + 10;
    [collectionView reloadData]; //让collectionView走数据源方法
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return IMAGECOUNT;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    KKTapImageView *tapImgView = [[KKTapImageView alloc]initWithFrame:CGRectMake(0, 0, IMAGESIZE, IMAGESIZE)];
    tapImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd",indexPath.item]];
    tapImgView.currentIndex = indexPath.row; //为collectionView中的每个图片添加标记
    tapImgView.currentRow = collectionView.tag; //标记当前tapImgView与tableView中所在行,防止cell重用引起的混乱
    tapImgView.helper.delegate = self;
    [cell.contentView addSubview:tapImgView];
    return cell;
    //后台接口如果有返缩略图,可设置先展示缩略图,点击放大时展示原图,并带加载进度
    //    [tapImgView sd_setImageWithURL:...缩略图];
    //    tapImgView.url = [NSURL URLWithString:....原图];
}
//KKimageviewHelper代理方法,返回当前tableView
- (UITableView *)getTableView{
    return self.tableView;
}
@end
