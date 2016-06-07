//
//  ViewController.m
//  scrollview
//
//  Created by Peng Dong on 16/5/5.
//  Copyright © 2016年 LucaPeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong)UIScrollView *myScrollView;
@property(nonatomic, strong)UIPageControl *myPageControl;
@property(nonatomic, assign)NSInteger currentPage;
@property(nonatomic, strong)NSMutableArray *views;
@property(nonatomic, strong)NSTimer *myTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadScrollView];
    [self loadPageControl];
    [self loadTimer];
    [self loadData];
}


-(void)loadScrollView{
    self.views = [[NSMutableArray alloc]initWithCapacity:3];
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 250)];
    _myScrollView.backgroundColor = [UIColor redColor];
    _myScrollView.pagingEnabled = YES;
    _myScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.myScrollView.frame.size.height) ;
    self.myScrollView.delegate = self;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_myScrollView];
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.myScrollView.frame.size.width * i, 0,self.myScrollView.frame.size.width, self.myScrollView.frame.size.height)];
        [_myScrollView addSubview:imageView];
    }
}

-(void)loadPageControl{
    _myPageControl = [[UIPageControl alloc]initWithFrame:
                      CGRectMake((_myScrollView.frame.size.width - 160)/2 , _myScrollView.frame.size.height - 16, 160, 16)];
    _myPageControl.numberOfPages = 4;
    _myPageControl.currentPage = 0;
    self.currentPage = 0;
    _myPageControl.currentPage  = self.currentPage;
    self.myPageControl.currentPageIndicatorTintColor=[UIColor yellowColor];
    self.myPageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:_myPageControl];
}


-(void)loadTimer{
    _myTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(changeImage:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSDefaultRunLoopMode];
}


-(void)changeImage:(NSTimer *)timer{
    
    if (!_myScrollView.isDragging)
    {
        
        NSInteger page = self.myPageControl.currentPage; // 获取当前的page
        
        page++;
        self.currentPage = page > 3 ? 0 : page;
        [self loadData];

    }
} 

-(void)loadData{
    NSArray *subViews = self.myScrollView.subviews;
    if ([subViews count] > 0) {
        for (UIView *view in subViews) {
            if ([view isMemberOfClass:[UIImageView class]]) {
                [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            }
        }
    }
    
    NSArray *imagesForShow = [self getCurrentImage:self.currentPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *view = subViews[i];
        [(UIImageView *)view setImage:imagesForShow[i]];
        [self.myScrollView addSubview:view];
    }
    _myPageControl.currentPage  = self.currentPage;
    [_myScrollView setContentOffset:CGPointMake(_myScrollView.frame.size.width, 0)];
}


-(NSArray *) getCurrentImage:(NSUInteger )currentPageNum{
    
    NSInteger prePageNum = currentPageNum - 1;
    NSUInteger nextPageNum = currentPageNum + 1;
    NSMutableArray *images = [[NSMutableArray alloc]initWithCapacity:3];
    
    if (prePageNum < 0) {
        prePageNum = 3;
    }
    if (nextPageNum > 3) {
        nextPageNum = 0;
    }
    
    [images addObject:[self loadImage:prePageNum]];
    [images addObject:[self loadImage:currentPageNum]];
    [images addObject:[self loadImage:nextPageNum]];
    return images;
}


-(UIImage *) loadImage:(NSInteger)pageNum{
    UIImage *image = [UIImage imageNamed: [NSString stringWithFormat:@"h%ld.jpg",(long)pageNum + 1]];
    return image;
}

#pragma scroll View Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int x = _myScrollView.contentOffset.x;
    //往下翻一张
    if(x >= (2 * self.view.frame.size.width)) {
        self.currentPage++;
        if (self.currentPage > 3) {
            self.currentPage = 0;
        }
        [self loadData];
    }
    //往上翻
    if(x <= 0) {
        self.currentPage--;
        if (self.currentPage < 0) {
            self.currentPage = 3;
        }
        [self loadData];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    [_myScrollView setContentOffset:CGPointMake(_myScrollView.frame.size.width, 0) animated:YES];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //使定时器失效
    [self.myTimer invalidate];
}

//设置代理方法,当拖拽结束的时候,调用计时器,让其继续自动滚动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //重新启动定时器
    [self loadTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
