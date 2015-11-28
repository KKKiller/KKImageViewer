//
//  ViewController.m
//  KKPhotoViewer
//
//  Created by 周吾昆 on 15/11/27.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import "ViewController.h"
#import "KKTableViewController.h"
#import "KKViewController.h"
#import "KKTapImageView.h"
static int headImageFlag  = 100;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.navigationItem.title = @"图片浏览器";
    self.view.backgroundColor = [UIColor purpleColor];
}

- (void)setUI{
    //任何位置的单张图片,直接以KKTapImageVIew代替UIImageView进行initWithFrame初始化即可,如果要做圆角处理,初始化时x值给100,之后再根据位置需要重新设置frame即可
    KKTapImageView *headImgView1 = [[KKTapImageView alloc]initWithFrame:CGRectMake(headImageFlag, 150, 100, 100)];
    headImgView1.frame = CGRectMake(140, 150, 100, 100);
    headImgView1.image = [UIImage imageNamed:@"head"];
    headImgView1.layer.cornerRadius = 50;
    headImgView1.layer.masksToBounds = YES;
    [self.view addSubview:headImgView1];
    
    KKTapImageView *headImgView2 = [[KKTapImageView alloc]initWithFrame:CGRectMake(140, 500, 100, 100)];
    headImgView2.image = [UIImage imageNamed:@"head"];
    [self.view addSubview:headImgView2];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 200, 40)];
    btn1.backgroundColor = [UIColor lightGrayColor];
    [btn1 setTitle:@"tableViewCell里的图片组" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 400, 200, 40)];
    btn2.backgroundColor = [UIColor lightGrayColor];
    [btn2 setTitle:@"任何位置的图片组" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)btn1Click{
    //tableView列表类图片组,每个cell中有一组图片
    KKTableViewController *vc = [[KKTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)btn2Click{
    //任何位置的单个图片组
    KKViewController *vc = [[KKViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
