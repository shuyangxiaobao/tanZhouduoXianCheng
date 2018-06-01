//
//  LoadImageViewController.m
//  多线程Pthread Nsthread GCD NSOperation
//
//  Created by 戈强宝 on 2018/5/31.
//  Copyright © 2018年 戈强宝. All rights reserved.
//

#import "LoadImageViewController.h"

@interface LoadImageViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,weak) UIImageView * imageView;
@property(nonatomic,strong) UIImage * image;

@end
@implementation LoadImageViewController

/**
 加载视图结构的,纯代码开发
 功能 SB&XIB 是一样
 如果重写了这个方法,SB和XIB 都无效
 */
-(void)loadView{
    //搭建界面
    self.scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.scrollView;
    //MARK:- 设置缩放属性
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 2.0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //imageView
    UIImageView * iv = [[UIImageView alloc]init];
    //会调用View的getter方法. loadView方法在执行的过程中!如果self.view == nil,会自动调用loadView加载!
    [self.view addSubview:iv];
    self.imageView = iv;
}


/**
 视图加载完毕
 一般做初始化工作
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //    [self downloadImage];
    
    
    NSThread * t1 = [[NSThread alloc]initWithTarget:self selector:@selector(downloadImage) object:nil];
    [t1 start];
    
    
    
}

//MARK: - 下载图片
-(void)downloadImage{
    
    NSLog(@"%@",[NSThread currentThread]);
    //NSURL -> 统一资源定位符,每一个URL 对应一个网络资源!
    NSURL * url = [NSURL URLWithString:@"http://img3.duitang.com/uploads/item/201604/27/20160427004300_QfKwt.jpeg"];
    
    //下载图片(在网络上传输的所有数据都是二进制!!)
    //为什么是二进制:因为物理层!!是网线!!网线里面是电流!!电流有高低电频!!高低电频表示二进制!!!
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    //将二进制数据转成图片并且设置图片
    //提示:不是所有的更新UI在后台线程支持都会有问题!!!
    //重点提示:不要去尝试在后台线程更新UI!!!出了问题是非常诡异的!!
    //    self.image = [UIImage imageWithData:data];
    
    //在UI线程去更新UI
    /**
     * 1.SEL:在主线程执行的方法
     * 2.传递给方法的参数
     * 3.让当前线程等待 (注意点!! 如果当前线程是主线程!哥么YES没有用!!)
     */
    // 线程间通讯
    [self performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageWithData:data] waitUntilDone:NO];
}

//这种写法 省略一个 _image ,主要原因是因为image 保存在了imageView里面了!
-(UIImage *)image{
    return self.imageView.image;
}


-(void)setImage:(UIImage *)image{
    NSLog(@"更新 UI 在====%@",[NSThread currentThread]);
    //直接将图片设置到控件上
    self.imageView.image = image;
    //让imageView和image一样大
    [self.imageView sizeToFit];
    //指定ScrollView 的contentSize
    self.scrollView.contentSize = image.size;
    
    NSLog(@"\n\n\n\n\n\n\n\n\n\n\n%@",self.image);
}

#pragma mark - <scrollView代理>
//告诉 ScrollView 缩放哪个View
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

/**
 * transform 矩阵
 *  CGFloat a(缩放比例), b, c, d(缩放比例);  共同决定角度!
 *  CGFloat tx(位移), ty(位移);
 
 *
 */
//-(void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    NSLog(@"%@",NSStringFromCGAffineTransform(self.imageView.transform));
//}


@end
