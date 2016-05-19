//
//  ViewController.m
//  CLRYesCurveFilter
//
//  Created by vk on 16/5/18.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage.h>

@interface ViewController ()
{

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GPUImageToneCurveFilter *curveFilterOne = [[GPUImageToneCurveFilter alloc]initWithACV:@"curves3"];
    GPUImageToneCurveFilter *curveFilterTwo = [[GPUImageToneCurveFilter alloc]initWithACV:@"curves2"];
    GPUImageToneCurveFilter *curveFilterThree = [[GPUImageToneCurveFilter alloc]initWithACV:@"curves1"];
    
    GPUImageFilterGroup *group = [self createGroupWith:curveFilterThree and:curveFilterTwo and:curveFilterOne];
    
    UIImage *srcImage = [UIImage imageNamed:@"yes.jpg"];
    float imageWidth = srcImage.size.width;
    float imageHeight = srcImage.size.height;
    float imagewDh = imageWidth/imageHeight;
    float viewWidth = [UIScreen mainScreen].bounds.size.width*9.0/10.0;
    float viewHeight = viewWidth/imagewDh;
    
    UIImageView *srcView = [[UIImageView alloc]initWithFrame:CGRectMake(viewWidth/9.0/2.0, 10, viewWidth , viewHeight)];
    srcView.image = srcImage;
    [self.view addSubview:srcView];
    
    UIImageView *dstView = [[UIImageView alloc]initWithFrame:CGRectMake(viewWidth/9.0/2.0, CGRectGetMaxY(srcView.bounds) + 10.0, viewWidth , viewHeight)];
    dstView.image = [self filterImage:srcImage withFilter:group];
    [self.view addSubview:dstView];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (UIImage *)filterImage:(UIImage *)srcImage withFilter:(GPUImageFilterGroup *)filter
{
    GPUImagePicture *pic = [[GPUImagePicture alloc]initWithImage:srcImage];
    [pic addTarget:filter];
    [filter useNextFrameForImageCapture];
    [pic processImage];
    UIImage *getImage = [filter imageFromCurrentFramebuffer];
    return getImage;
}

- (GPUImageFilterGroup *)createGroupWith:(GPUImageFilter *)filter1 and:(GPUImageFilter *)filter2 and:(GPUImageFilter *)filter3
{
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc]init];
    [group addTarget:filter1];
    [group addTarget:filter2];
    [group addTarget:filter3];
    
    [filter1 addTarget:filter2];
    [filter2 addTarget:filter3];
    group.initialFilters = [NSArray arrayWithObject:filter1];
    group.terminalFilter = filter3;
    return group;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
