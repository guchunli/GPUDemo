//
//  GPUImageFilterViewController.m
//  GCLGPUApp
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 guchunli. All rights reserved.
//

#import "GPUImageFilterViewController.h"
#import <GPUImage.h>

@interface GPUImageFilterViewController ()

@property (nonatomic,strong)GPUImageBrightnessFilter *brightnessFilter;
@property (nonatomic,strong)GPUImageBilateralFilter *bilateralFilter;
@property (nonatomic,strong)GPUImageVideoCamera *videoCamera;

@end

@implementation GPUImageFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.视频源
    /*
     SessionPreset:屏幕分辨率
     cameraPosition：摄像头方向
     */
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera = videoCamera;
    
    //2.创建最终预览view
    GPUImageView *captureVideoPreview = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    [self.view insertSubview:captureVideoPreview atIndex:0];
    
    //3.创建滤镜：美白、磨皮、组合滤镜
    GPUImageFilterGroup *groupFilter = [[GPUImageFilterGroup alloc]init];
    
    //美白滤镜
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc]init];
    [groupFilter addTarget:brightnessFilter];
    _brightnessFilter = brightnessFilter;
    
    //磨皮滤镜
    GPUImageBilateralFilter *bilateralFilter = [[GPUImageBilateralFilter alloc]init];
    [groupFilter addTarget:bilateralFilter];
    _bilateralFilter = bilateralFilter;
    
    //设置滤镜组链
    [brightnessFilter addTarget:bilateralFilter];
    [groupFilter setInitialFilters:@[brightnessFilter]];
    groupFilter.terminalFilter = bilateralFilter;
    
    //设置GPUImage处理链，从数据源-》滤镜-》最终界面
    [videoCamera addTarget:groupFilter];
    [groupFilter addTarget:captureVideoPreview];
    
    //4.开始采集视频
    //必须调用startCameraCapture,底层才会把采集到的视频源渲染到GPUImageView
    [videoCamera startCameraCapture];
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self dismissViewControllerAnimated:YES completion:nil];
}
//美白滤镜
- (IBAction)brigntnessFilter:(UISlider *)sender {

    _brightnessFilter.brightness = sender.value;
}

//磨皮滤镜
- (IBAction)bilateralFilter:(UISlider *)sender {

    //值越小，磨皮效果越好,distanceNormalizationFactor取值范围: 大于1
    CGFloat maxValue = 10;
    [_bilateralFilter setDistanceNormalizationFactor:(maxValue-sender.value)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
