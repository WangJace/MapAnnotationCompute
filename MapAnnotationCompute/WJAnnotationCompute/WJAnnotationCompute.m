//
//  WJAnnotationCompute.m
//  MapAnnotationCompute
//
//  Created by Wang on 15/12/28.
//  Copyright © 2015年 WangJace. All rights reserved.
//

#import "WJAnnotationCompute.h"
#import "WJAnnotationModel.h"
#import <MAMapKit/MAMapKit.h>

@implementation WJAnnotationCompute

/**
 *  传入一个数组，数组中为地图上的标注数据，遍历数组，根据给定距离计算需要合并的标注，并返回一个标注数组
 *
 *  @param array    数组（数组元素为WJAnnotationModel对象）
 *  @param distance 标注之间的最小距离
 *
 *  @return 返回计算后的标注数组
 */
+(NSMutableArray *)rangeMapDataWithArray:(NSArray *)array Distance:(CGFloat)distance
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    //两次遍历，当某个标注MAUserAnnotation被合并，则改标注的flag属性改为YES，之后的遍历就可跳过此标注
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //数组中有可能存在当前位置（MAUserLocation）或者其他非WJAnnotationModel类的对象
        if ([[array objectAtIndex:idx] isKindOfClass:[WJAnnotationModel class]]) {
            //当前作为距离判断基点的标注
            WJAnnotationModel *selectedAnnotation = [array objectAtIndex:idx];
            //判断标注是否已经被合并
            if (!selectedAnnotation.flag) {
                //新建一个标注
                WJAnnotationModel *userAnnotation = [[WJAnnotationModel alloc] init];
                //设置标注的初始化经纬度，后面若出现标注合并，这两个值则为所有合并标注的经度之和和纬度之和
                CGFloat totalLatitude = selectedAnnotation.coordinate.latitude;
                CGFloat totalLongitude = selectedAnnotation.coordinate.longitude;
                //合并的标注个数，刚开始只有selectedAnnotation这个基点标注，故count的初始值为1
                CGFloat count = 1;
                //初始化标注的一些属性
                userAnnotation.imageURL = selectedAnnotation.imageURL;
                userAnnotation.title = selectedAnnotation.title;
                userAnnotation.myId = selectedAnnotation.myId;
                userAnnotation.subtitle = selectedAnnotation.subtitle;
                userAnnotation.flag = NO;
                //记录此次合并标注的最小距离
                userAnnotation.distance = distance;
                //第二层遍历，以selectedAnnotation为基点，判断数组中哪些标注在一个以selectedAnnotation为圆心，distance为半径的圆中
                for (NSUInteger j = idx+1; j < array.count; j++) {
                    //数组中有可能存在当前位置（MAUserLocation）或者其他非WJAnnotationModel类的对象
                    if ([[array objectAtIndex:idx] isKindOfClass:[WJAnnotationModel class]]) {
                        //当前被判断的标注
                        WJAnnotationModel *contrast = [array objectAtIndex:j];
                        //判断标注是否已经被合并
                        if (!contrast.flag) {
                            //判断contrast是否在selectedAnnotation的圆形区域中
                            if (MACircleContainsCoordinate(selectedAnnotation.coordinate,contrast.coordinate,distance)) {
                                //标注合并
                                if (userAnnotation.dataSource == nil) {
                                    //初始化标注数组
                                    userAnnotation.dataSource = [[NSMutableArray alloc] init];
                                    //判断基点标注是否存在合并标注
                                    if (selectedAnnotation.dataSource) {
                                        [userAnnotation.dataSource addObjectsFromArray:selectedAnnotation.dataSource];
                                    }
                                    else {
                                        [userAnnotation.dataSource addObject:selectedAnnotation];
                                    }
                                }
                                //判断contrast的dataSource是否为nil，若不为nil，则证明此标注做个合并，有多个标注在此点，则将这些标注加入到新的标注中
                                if (contrast.dataSource) {
                                    [userAnnotation.dataSource addObjectsFromArray:contrast.dataSource];
                                }
                                else {
                                    [userAnnotation.dataSource addObject:contrast];
                                }
                                //将此标注的flag值改为YES，表示此标注已经被合并
                                contrast.flag = YES;
                                //改变此合并标注的总经度和总纬度
                                totalLatitude += contrast.coordinate.latitude;
                                totalLongitude += contrast.coordinate.longitude;
                                //合并标注个数加1
                                count++;
                            }
                        }
                    }
                }
                
                //判断合并标注的个数
                if (count == 1) {
                    //count值为1，证明没有发生过标注合并
                    userAnnotation.coordinate = CLLocationCoordinate2DMake(totalLatitude, totalLongitude);
                    if (selectedAnnotation.dataSource) {
                        userAnnotation.dataSource = [[NSMutableArray alloc] initWithArray:selectedAnnotation.dataSource];
                    }
                }
                else {
                    //将所有合并的标注的经度平均值和纬度平均值作为新标注的经纬度值
                    userAnnotation.coordinate = CLLocationCoordinate2DMake(totalLatitude/count, totalLongitude/count);
                }
                [annotations addObject:userAnnotation];
            }
        }
    }];
    
    [annotations enumerateObjectsUsingBlock:^(WJAnnotationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.dataSource) {
            [obj.dataSource enumerateObjectsUsingBlock:^(WJAnnotationModel * _Nonnull item, NSUInteger index, BOOL * _Nonnull finishMapAnnotationCompute) {
                item.flag = NO;
            }];
        }
    }];
    return annotations;
}
//地图区域的比例和原来比例不一样的时候调用
+(NSArray *)calculateMapDataWithArray:(NSArray *)array Distance:(NSNumber *)distance
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //数组中有可能存在当前位置（MAUserLocation）或者其他非WJAnnotationModel类的对象
        if ([[array objectAtIndex:idx] isKindOfClass:[WJAnnotationModel class]]) {
            WJAnnotationModel *item = [array objectAtIndex:idx];
            if ((NSInteger)item.distance < [distance integerValue]) {
                //地图处于缩小状态，比例尺变小
                [annotations addObjectsFromArray:array];
                *stop = YES;
            }
            else {
                //地图处于放大状态，比例尺变大
                if (item.dataSource) {
                    //同一标注有多个用户，重新计算多个用户之间的距离，生成新的数组
                    [annotations addObjectsFromArray:[self rangeMapDataWithArray:item.dataSource Distance:[distance floatValue]]];
                }
                else {
                    //此标注只有一个用户
                    item.distance = [distance floatValue];
                    [annotations addObject:item];
                }
            }
        }
    }];
    return [self rangeMapDataWithArray:annotations Distance:[distance floatValue]];
}

@end
