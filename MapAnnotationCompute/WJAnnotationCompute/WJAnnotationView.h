//
//  WJAnnotationView.h
//  MapAnnotationCompute
//
//  Created by Wang on 15/12/28.
//  Copyright © 2015年 WangJace. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface WJAnnotationView : MAAnnotationView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,assign) NSInteger count;

@end
