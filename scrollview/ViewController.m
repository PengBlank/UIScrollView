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
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 250)];
    _myScrollView.backgroundColor = [UIColor redColor];
    _myScrollView.pagingEnabled = YES;
    _myScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height) ;
    self.myScrollView.delegate = self;
    [self.view addSubview:_myScrollView];
}

-(void)loadPageControl{
    _myPageControl = [[UIPageControl alloc]initWithFrame:
                      CGRectMake((_myScrollView.frame.size.width - 160)/2 , _myScrollView.frame.size.height - 16, 160, 16)];
    _myPageControl.numberOfPages = 4;
    _myPageControl.currentPage = 0;
    self.myPageControl.currentPageIndicatorTintColor=[UIColor yellowColor];
    self.myPageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:_myPageControl];
}


-(void)loadTimer{
    _myTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(changeImage:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSDefaultRunLoopMode];
}


-(void)changeImage:(NSTimer *)timer{
    
    if (!_myScrollView.isDragging)
    {
        CGPoint newOffset = CGPointMake(_myScrollView.contentOffset.x + CGRectGetWidth(_myScrollView.frame), _myScrollView.contentOffset.y);
        
        if ((int)newOffset.x%(int)CGRectGetWidth(_myScrollView.frame) != 0)
        {
            newOffset.x = (_myPageControl.currentPage+1)*CGRectGetWidth(_myScrollView.frame);
        };
        
        [_myScrollView setContentOffset:newOffset animated:YES];
        self.myPageControl.currentPage = newOffset.x / self.myScrollView.frame.size.width;
        //DebugNSLog(@"autoPlayAds %@", self);
    }
}

-(void)loadData{
    
    NSUInteger pageNum = self.myPageControl.currentPage;
    NSArray *imageViews = [self getCurrentImage:pageNum];
    
    for (int i = 0; i < imageViews.count; i++) {
//        [_myScrollView addSubview:imageViews[i]];
        UIView *v = [imageViews objectAtIndex:i];
        v.frame = CGRectMake(v.frame.size.width*i,
                             0,
                             v.frame.size.width,
                             v.frame.size.height);//CGRectOffset(v.frame, v.frame.size.width * i, 0);
        v.clipsToBounds = YES;
        [_myScrollView addSubview:v];
    }
    
    
//    CGPoint offset = self.myScrollView.contentOffset;
//    
//    if (pageNum >= 3) {
//        pageNum = 0;
//        offset.x = 0;
//    }else{
//        pageNum += 1;
//        offset.x += self.myScrollView.frame.size.width;
//    }
//    self.myPageControl.currentPage = pageNum;
//    [self.myScrollView setContentOffset:offset animated:YES];
}


-(NSArray *) getCurrentImage:(NSUInteger )currentPageNum{
    
    NSInteger prePageNum = currentPageNum - 1;
    NSUInteger nextPageNum = currentPageNum + 1;
    NSMutableArray *views = [[NSMutableArray alloc]initWithCapacity:3];
    
    if (prePageNum < 0) {
        prePageNum = 3;
    }
    if (nextPageNum > 3) {
        nextPageNum = 0;
    }
    
    [views addObject:[self loadImageWithPageNum:prePageNum]];
    [views addObject:[self loadImageWithPageNum:currentPageNum]];
    [views addObject:[self loadImageWithPageNum:nextPageNum]];
    return views;
}

-(UIView *) loadImageWithPageNum:(NSInteger )pageNum{
    UIImage *image = [UIImage imageNamed: [NSString stringWithFormat:@"h%ld.jpg",(long)pageNum + 1]];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGRectGetHeight(self.view.frame))];
    imageView.image = image;
    return imageView;
}

#pragma scroll View Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //使定时器失效
    [self.myTimer invalidate];
}

//根据偏移量获取当前页码
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取偏移量
    CGPoint offset=scrollView.contentOffset;
    //计算当前页码
    NSInteger currentPage=offset.x / self.myScrollView.frame.size.width;
    //设置当前页码
    self.myPageControl.currentPage=currentPage;
    
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
