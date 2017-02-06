//
//  BeautyFilterViewController.m
//  GCLGPUApp
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 guchunli. All rights reserved.
//

#import "BeautyFilterViewController.h"
#import <GPUImage.h>
#import "GPUImageBeautifyFilter.h"

@interface BeautyFilterViewController ()

@property (nonatomic,strong)GPUImageVideoCamera *videoCamera;
@property (nonatomic,strong)GPUImageView *captureVideoPreview;
@end

@implementation BeautyFilterViewController

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
    _captureVideoPreview = captureVideoPreview;
    
    //3.设置处理链
    [_videoCamera addTarget:_captureVideoPreview];
    
    //4.开始采集视频
    //必须调用startCameraCapture,底层才会把采集到的视频源渲染到GPUImageView
    [videoCamera startCameraCapture];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openBeautyFilter:(UISwitch *)sender {
    
    //远离：移除之前所有处理链，重新设置处理链
    if (sender.on) {
        
        //1.移除之前所有处理链
        [_videoCamera removeAllTargets];
        
        //2.创建美颜滤镜
        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
        
        //3.设置GPUImage处理链，从数据源-》滤镜-》最终界面
        [_videoCamera addTarget:beautifyFilter];
        [beautifyFilter addTarget:_captureVideoPreview];
    }else{
    
        //移除之前所有处理链
        [_videoCamera removeAllTargets];
        [_videoCamera addTarget:_captureVideoPreview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
