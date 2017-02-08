//
//  ViewController.m
//  类似于广告的图片轮播
//
//  Created by xiayuanqun on 17/2/8.
//  Copyright © 2017年 xiayuanqun. All rights reserved.
//

#import "ViewController.h"
#define count 5
@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic)UIScrollView *scrollView;
@property (weak, nonatomic)UIPageControl *pageView;
@property (weak, nonatomic)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareScrollView];
    [self preparePageView];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)prepareScrollView{
    CGFloat scrollW = [UIScreen mainScreen].bounds.size.width;
    CGFloat scrollH = 200; //[UIScreen mainScreen].bounds.size.height;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, scrollW,scrollH)];
    scrollView.delegate = self;
    for(int i = 0;i < count; i++){
        UIImageView *imageView = [[UIImageView alloc]init];
        NSString *name = [NSString stringWithFormat:@"img_%02d",i + 1];
        imageView.image = [UIImage imageNamed:name];
        CGFloat imageX = scrollW * (i + 1);
        imageView.frame = CGRectMake(imageX, 0, scrollW, scrollH);
        [scrollView addSubview:imageView];
    }
    UIImageView *firstImage = [[UIImageView alloc]init];
    firstImage.image = [UIImage imageNamed:@"img_05"];
    firstImage.frame = CGRectMake(0, 0, scrollW, scrollH);
    [scrollView addSubview:firstImage];
    scrollView.contentOffset =CGPointMake(scrollW, 0);
    
    UIImageView *lastImage = [[UIImageView alloc]init];
    lastImage.image = [UIImage imageNamed:@"img_01"];
    lastImage.frame = CGRectMake((count + 1) * scrollW, 0, scrollW, scrollH);
    [scrollView addSubview:lastImage];
    scrollView.contentSize = CGSizeMake((count + 2) * scrollW, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [self addTimer];
}
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)nextImage{
    CGFloat width = self.scrollView.frame.size.width;
    NSInteger index = self.pageView.currentPage;
    if(index == count + 1){
        index = 0;
    }else{
        index ++;
    }
    [self.scrollView setContentOffset:CGPointMake((index + 1) * width, 0) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = self.scrollView.frame.size.width;
    int index = (self.scrollView.contentOffset.x + width * 0.5) / width;
    if (index == count + 2){
        index = 1;
    }else if (index == 0){
        index = count;
    }
    self.pageView.currentPage = index - 1;;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = self.scrollView.frame.size.width;
    int index = (self.scrollView.contentOffset.x + width * 0.5) / width;
    if (index == count + 1){
        [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
    }else if (index == 0){
        [self.scrollView setContentOffset:CGPointMake(count * width, 0) animated:NO];
    }
}
- (void)preparePageView {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat pageW = 100;
    UIPageControl *pageView = [[UIPageControl alloc] initWithFrame:CGRectMake((width - pageW) * 0.5, 190, pageW, 4)];
    pageView.numberOfPages = count;
    pageView.currentPageIndicatorTintColor = [UIColor redColor];
    pageView.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageView.currentPage = 0;
    [self.view addSubview:pageView];
    self.pageView = pageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
