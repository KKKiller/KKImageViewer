//
//  TapImageView.m
//  TestLayerImage
//
//  Created by 周吾昆 on 15/10/8.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import "KKTapImageView.h"
#import "KKImageViewerHelper.h"
@implementation KKTapImageView
- (void)dealloc
{
    _t_delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
        [self addGestureRecognizer:tap];
        
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = YES;
        
        
        UIButton *tapView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        tapView.backgroundColor = [UIColor clearColor];
        [tapView addTarget:self action:@selector(tapViewClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tapView];
        self.tapView = tapView;
        KKImageViewerHelper *helper = [[KKImageViewerHelper alloc]init];
        self.helper = helper;
        if (frame.origin.x == 100) {
            self.helper.isHeadImg = YES;
        }
    }
    return self;
}
- (void)tapViewClick{
    [self.helper tappedAtImgview:self];
}
- (void) Tapped:(UIGestureRecognizer *) gesture
{
    if ([self.t_delegate respondsToSelector:@selector(tappedWithObject:)])
    {
        [self.t_delegate tappedWithObject:self];
    }
}
@end
