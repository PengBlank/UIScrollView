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
    _myScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.myScrollView.frame.size.height) ;
    self.myScrollView.delegate = self;
    [self.view addSubview:_myScrollView];
}

-(void)loadPageControl{
    _myPageControl = [[UIPageControl alloc]initWithFrame:
                      CGRectMake((_myScrollView.frame.size.width - 160)/2 , _myScrollView.frame.size.height - 16, 160, 16)];
    _myPageControl.numberOfPages = 4;
    _myPageControl.currentPage = 0;
    self.currentPage = 0;
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
        CGPoint newOffset = CGPointMake(CGRectGetWidth(_myScrollView.frame), _myScrollView.contentOffset.y);
        
        if ((int)newOffset.x%(int)CGRectGetWidth(_myScrollView.frame) != 0)
        {
            newOffset.x = (_myPageControl.currentPage+1)*CGRectGetWidth(_myScrollView.frame);
        };
        
        [_myScrollView setContentOffset:newOffset animated:YES];
//        self.myPageControl.currentPage = newOffset.x / self.myScrollView.frame.size.width;
//        [self getCurrentImage:(newOffset.x / self.myScrollView.frame.size.width) ];
//        [self loadData];
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
     [_myScrollView setContentOffset:CGPointMake(_myScrollView.frame.size.width, 0) animated:NO];
//    self.myPageControl.currentPage = 0;
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
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGRectGetHeight(self.myScrollView.frame))];
    imageView.image = image;
    return imageView;
}

#pragma scroll View Delegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果scrollView当前偏移位置x大于等于两倍scrollView宽度
    if (_myScrollView.contentOffset.x >= self.myScrollView.frame.size.width * 2) {
        //当前图片位置+1
        _currentPage++;
        //如果当前图片位置超过数组边界，则设置为0
//        if (_currentPage == [self.imageArray count]) {
//            _currentPage = 0;
//        }
        [self getCurrentImage:self.currentPage];
        //刷新图片
        [self loadData];
        //设置scrollView偏移位置
//        [_myScrollView setContentOffset:CGPointMake(c_width, 0)];
    }
    
    //如果scrollView当前偏移位置x小于等于0
    else if (_myScrollView.contentOffset.x <= 0) {
        //当前图片位置-1
        _currentPage--;
        [self getCurrentImage:_currentPage];
        //如果当前图片位置小于数组边界，则设置为数组最后一张图片下标
//        if (_currentPage == -1) {
//            _currentPage = [self.imageArray count]-1;
//        }
        //刷新图片
        [self loadData];
        //设置scrollView偏移位置
//        [_myScrollView setContentOffset:CGPointMake(c_width, 0)];
    }
}








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
