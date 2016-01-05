//
//  WJAnnotationCompute.h
//  MapAnnotationCompute
//
//  Created by Wang on 15/12/28.
//  Copyright © 2015年 WangJace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJAnnotationCompute : NSObject
/**
 *  根据给定的数组和距离重新计算出当前地图缩放比例下的数据排列
 *
 *  @param arr      数组
 *  @param distance 距离
 *
 *  @return 重新计算之后返回的数组
 */
+(NSArray *)calculateMapDataWithArray:(NSArray *)arr Distance:(NSNumber *)distance;

@end
