//
//  WJAnnotationView.m
//  MapAnnotationCompute
//
//  Created by Wang on 15/12/28.
//  Copyright © 2015年 WangJace. All rights reserved.
//

#import "WJAnnotationView.h"

@implementation WJAnnotationView

-(instancetype)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) {
        self.bounds = CGRectMake(0, 0, 50, 50);
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 25;
        [self addSubview:_imageView];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, -5, 20, 20)];
        _countLabel.backgroundColor = [UIColor redColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.hidden = YES;
        _countLabel.layer.cornerRadius = 10;
        _countLabel.layer.masksToBounds = YES;
        [self addSubview:_countLabel];
    }
    return self;
}

-(void)setCount:(NSInteger)count
{
    if (count == 0) {
        _countLabel.hidden = YES;
    }
    else if (count > 0 && count <= 99) {
        _countLabel.hidden = NO;
        _countLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
        _countLabel.font = [UIFont systemFontOfSize:10];
    }
    else {
        _countLabel.hidden = NO;
        _countLabel.text = @"99+";
        _countLabel.font = [UIFont systemFontOfSize:7];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
