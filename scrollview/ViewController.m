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
    
}


-(void)loadScrollView{
    UIImageView *myImageView = nil;
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 250)];
    _myScrollView.backgroundColor = [UIColor redColor];
    _myScrollView.pagingEnabled = YES;
    for (int i = 0; i <= 3; i++) {
        myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * myImageView.frame.size.width, 0, self.view.frame.size.width, 250)];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"h%d.jpg",i+1]];
        myImageView.image = image ;
        [_myScrollView addSubview:myImageView];
    }
    _myScrollView.contentSize = CGSizeMake(myImageView.frame.size.width * 4, myImageView.frame.size.height) ;
    
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
    
    NSUInteger pageNum = self.myPageControl.currentPage;
    CGPoint offset = self.myScrollView.contentOffset;
    
    if (pageNum >= 3) {
        pageNum = 0;
        offset.x = 0;
    }else{
        pageNum += 1;
        offset.x += self.myScrollView.frame.size.width;
    }
    self.myPageControl.currentPage = pageNum;
    [self.myScrollView setContentOffset:offset animated:YES];
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
