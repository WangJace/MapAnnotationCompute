//
//  WJAnnotationModel.m
//  MapAnnotationCompute
//
//  Created by Wang on 15/12/27.
//  Copyright © 2015年 WangJace. All rights reserved.
//

#import "WJAnnotationModel.h"

@implementation WJAnnotationModel

-(instancetype)initWithMyId:(NSString *)myId ImageURL:(NSString *)imageURL Title:(NSString *)title Subtitle:(NSString *)subtitle Coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        _myId = myId;
        _imageURL = imageURL;
        _title = title;
        _subtitle = subtitle;
        _coordinate = coordinate;
        _dataSource = nil;
        _flag = NO;
        _distance = 0.0;
    }
    return self;
}

@end
