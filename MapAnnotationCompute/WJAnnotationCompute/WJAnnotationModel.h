//
//  WJAnnotationModel.h
//  MapAnnotationCompute
//
//  Created by Wang on 15/12/27.
//  Copyright © 2015年 WangJace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface WJAnnotationModel : NSObject <MAAnnotation>
/**
 *  id
 */
@property (nonatomic,copy) NSString *myId;
/**
 *  图片链接
 */
@property (nonatomic,copy) NSString *imageURL;
/**
 *  标题
 */
@property (nonatomic,copy) NSString *title;
/**
 *  子标题
 */
@property (nonatomic,copy) NSString *subtitle;
/**
 *  经纬度
 */
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
/**
 *  地图显示中，如dataSource不为nil且长度不为0，证明同一标注有多个用户，dataSource里的元素是WJAnnotationModel对象，即该标注上的所有用户
 */
@property (nonatomic,strong) NSMutableArray<WJAnnotationModel *> *dataSource;
/**
 *  此属性用于在遍历的时候标记是否被遍历过了，目的是加快地图标注计算的速度
 */
@property (nonatomic,assign) BOOL flag;
/**
 *  距离，根据地图的显示比例，改变两点合并的最小距离，若两点距离小于这个最小距离，则两点合并
 */
@property (nonatomic,assign) CGFloat distance;

/**
 *  自定义初始化方法
 *
 *  @param myId       id
 *  @param imageURL   图片链接
 *  @param title      标题
 *  @param subtitle   子标题
 *  @param coordinate 经纬度
 *
 *  @return 实例化的WJAnnotationModel对象
 */
-(instancetype)initWithMyId:(NSString *)myId ImageURL:(NSString *)imageURL Title:(NSString *)title Subtitle:(NSString *)subtitle Coordinate:(CLLocationCoordinate2D)coordinate;

@end
