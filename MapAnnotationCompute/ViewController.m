//
//  ViewController.m
//  MapAnnotationCompute
//
//  Created by Wang on 15/12/27.
//  Copyright © 2015年 WangJace. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "WJAnnotationModel.h"
#import "WJAnnotationCompute.h"
#import "WJAnnotationView.h"

@interface ViewController ()<MAMapViewDelegate>
{
    NSMutableArray *_mapViewDataSource;
    CGFloat _recordDistance;
}
@property (nonatomic,strong) MAMapView *myMapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _recordDistance = 0.0;
    
    [self loadMapViewDataSource];
    [self createUI];
}

-(void)createUI
{
    _myMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _myMapView.delegate = self;
    _myMapView.centerCoordinate = CLLocationCoordinate2DMake(22.631949, 114.13161);
    [self.view addSubview:_myMapView];
    
    [_myMapView addAnnotations:_mapViewDataSource];
}

-(void)loadMapViewDataSource
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MapViewDataSource" ofType:@"csv"];
    NSError *error = nil;
    NSString *fileContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        NSArray *allLineString = [fileContent componentsSeparatedByString:@"\r\n"];
        _mapViewDataSource = [[NSMutableArray alloc] init];
        [allLineString enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                NSString *trimmedString = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSArray *locationData = [trimmedString componentsSeparatedByString:@","];
                if (locationData.count == 7) {
                    WJAnnotationModel *model = [[WJAnnotationModel alloc] initWithMyId:locationData[0]
                                                                              ImageURL:[NSString stringWithFormat:@"%ld",[locationData[0] integerValue]%10+1]
                                                                                 Title:locationData[3]
                                                                              Subtitle:locationData[4]
                                                                            Coordinate:CLLocationCoordinate2DMake([locationData[2] doubleValue], [locationData[1] doubleValue])];
                    [_mapViewDataSource addObject:model];
                }
            }
        }];
    }
    else {
        NSLog(@"获取数据出错，error = %@",error);
    }
}

#pragma mark - MAMapViewDelegate
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    static NSString *identifier = @"MKAnnotationView";
    WJAnnotationView *annotationView = (WJAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[WJAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    WJAnnotationModel *model = (WJAnnotationModel *)annotation;
    annotationView.centerOffset = CGPointMake(0, -30);
    annotationView.canShowCallout = NO;//设置气泡可以弹出，默认为NO
    annotationView.count = model.dataSource.count;
    annotationView.image = [UIImage imageNamed:model.imageURL];
    return annotationView;
}

-(void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CGFloat distance = 70*[mapView metersPerPointForCurrentZoomLevel];
    if (fabs(distance-_recordDistance) > 50) {
        _recordDistance = distance;
        NSArray *array = [WJAnnotationCompute calculateMapDataWithArray:mapView.annotations Distance:[NSNumber numberWithFloat:distance]];
        [mapView removeAnnotations:_mapViewDataSource];
        [_mapViewDataSource removeAllObjects];
        [_mapViewDataSource addObjectsFromArray:array];
        [mapView addAnnotations:_mapViewDataSource];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
