//
//  LK_InfiniteCarouselView.m
//  LK_InfiniteCarousel
//
//  Created by zhys_lk on 2018/6/26.
//  Copyright © 2018年 zhys_lk. All rights reserved.
//



#import "LK_InfiniteCarouselView.h"
#import "UIImageView+WebCache.h"

@interface LK_InfiniteCarouselView()<UIScrollViewDelegate>
@property(nonatomic, weak) UIScrollView *imageScrollView;
@property(nonatomic, weak) UIPageControl *imagePageControl;
@property(nonatomic, weak) UIImageView *imageFrist;
@property(nonatomic, weak) UIImageView *imageSecond;
@property(nonatomic, weak) UIImageView *imageThird;
@property(assign, nonatomic) NSInteger imageCurrenNum;
@property(assign, nonatomic) NSInteger imageTotalNum;
@property(strong, nonatomic) NSArray *dataArray;
@end

@implementation LK_InfiniteCarouselView

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame withInfiniteCarouselViewType:(InfiniteCarouselViewType)icvType withImageData:(NSArray *)imageArray {
    self = [super initWithFrame:frame];
    if (self) {
        if (imageArray.count == 0) {
            self.dataArray = @[@"1",@"2"];
        } else {
            self.dataArray = imageArray;
        }
        self.imageTotalNum = self.dataArray.count;
        self.imageCurrenNum = 0;
        [self initSubView];
        [self createTimer];
    }
    return self;
}

- (void)createTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
}

- (void)timerMethod {
    [UIView animateWithDuration:0.5 animations:^{
        self.imageScrollView.contentOffset = CGPointMake(2*self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.imageScrollView];
    }];
}


- (void)initSubView {
    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageScrollView.delegate = self;
    imageScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    imageScrollView.contentSize = CGSizeMake(self.frame.size.width*3, 0);
    imageScrollView.pagingEnabled = YES;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:imageScrollView];
    self.imageScrollView = imageScrollView;
    
    UIImageView *imageThird = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    if ([self dataIsLocalData]) {
        imageThird.image = [UIImage imageNamed:self.dataArray[self.imageTotalNum-1]];
    } else {
        [imageThird sd_setImageWithURL:[NSURL URLWithString:self.dataArray[self.imageTotalNum-1]] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    [self.imageScrollView addSubview:imageThird];
    self.imageThird = imageThird;
    
    UIImageView *imageFrist = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    if ([self dataIsLocalData]) {
        imageFrist.image = [UIImage imageNamed:self.dataArray[0]];
    } else {
        [imageFrist sd_setImageWithURL:[NSURL URLWithString:self.dataArray[0]] placeholderImage:[UIImage imageNamed:@""]];
    }
    [imageFrist addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickMethod)]];
    [self.imageScrollView addSubview:imageFrist];
    self.imageFrist = imageFrist;
    
    UIImageView *imageSecond = [[UIImageView alloc] initWithFrame:CGRectMake(2*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    if ([self dataIsLocalData]) {
        imageSecond.image = [UIImage imageNamed:self.dataArray[1]];
    } else {
        [imageSecond sd_setImageWithURL:[NSURL URLWithString:self.dataArray[1]] placeholderImage:[UIImage imageNamed:@""]];
    }
    [self.imageScrollView addSubview:imageSecond];
    self.imageSecond = imageSecond;
    
    UIPageControl *imagePageControl = [[UIPageControl alloc] init];
    imagePageControl.center = CGPointMake(self.center.x, self.frame.size.height*0.9);
    imagePageControl.bounds = CGRectMake(0, 0, self.frame.size.width*0.3, 10);
    imagePageControl.numberOfPages = self.dataArray.count;
    imagePageControl.currentPage = 0;
    imagePageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    imagePageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:imagePageControl];
    self.imagePageControl = imagePageControl;
}

- (void)imageClickMethod {
    if (self.infiniteCarouselViewClickB) {
        self.infiniteCarouselViewClickB(self.imageCurrenNum);
    }
    if ([self.delegate respondsToSelector:@selector(infiniteCarouselViewClickMethod:)]) {
        [self.delegate infiniteCarouselViewClickMethod:self.imageCurrenNum];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self dataIsLocalData]) {
        if (self.imageTotalNum > 2) {
            if (scrollView.contentOffset.x > (self.frame.size.width*1.5)) {
                self.imageCurrenNum++;
                if (self.imageCurrenNum == self.imageTotalNum) {
                    self.imageCurrenNum = 0;
                }
                NSLog(@"%ld",self.imageCurrenNum);
            } else if (scrollView.contentOffset.x < (self.frame.size.width * 0.5)){
                self.imageCurrenNum--;
                
                if (self.imageCurrenNum == -1) {
                    self.imageCurrenNum = self.imageTotalNum-1;
                }
                NSLog(@"%ld",self.imageCurrenNum);
            }
            if (self.imageCurrenNum == self.imageTotalNum - 1) {
                self.imageThird.image = [UIImage imageNamed:self.dataArray[self.imageCurrenNum-1]];
                self.imageSecond.image = [UIImage imageNamed:self.dataArray[0]];
            } else if (self.imageCurrenNum == 0) {
                self.imageThird.image = [UIImage imageNamed:self.dataArray[self.imageTotalNum-1]];
                self.imageSecond.image = [UIImage imageNamed:self.dataArray[self.imageCurrenNum+1]];
            } else {
                self.imageThird.image = [UIImage imageNamed:self.dataArray[self.imageCurrenNum-1]];
                self.imageSecond.image = [UIImage imageNamed:self.dataArray[self.imageCurrenNum+1]];
            }
            self.imageFrist.image = [UIImage imageNamed:self.dataArray[self.imageCurrenNum]];
            
        } else {
            if (scrollView.contentOffset.x > (self.frame.size.width*1.5)) {
                self.imageCurrenNum++;
                if (self.imageCurrenNum == self.imageTotalNum) {
                    self.imageCurrenNum = 0;
                }
                NSLog(@"%ld",self.imageCurrenNum);
            } else if (scrollView.contentOffset.x < (self.frame.size.width * 0.5)){
                self.imageCurrenNum--;
                if (self.imageCurrenNum == -1) {
                    self.imageCurrenNum = 1;
                }
            }
            if (self.imageCurrenNum == self.imageTotalNum - 1) {
                self.imageThird.image = [UIImage imageNamed:self.dataArray[0]];
                self.imageSecond.image = [UIImage imageNamed:self.dataArray[0]];
            } else if (self.imageCurrenNum == 0) {
                self.imageThird.image = [UIImage imageNamed:self.dataArray[1]];
                self.imageSecond.image = [UIImage imageNamed:self.dataArray[1]];
            }
            self.imageFrist.image = [UIImage imageNamed:self.dataArray[self.imageCurrenNum]];
        }
    } else {
        if (self.imageTotalNum > 2) {
            if (scrollView.contentOffset.x > (self.frame.size.width*1.5)) {
                self.imageCurrenNum++;
                if (self.imageCurrenNum == self.imageTotalNum) {
                    self.imageCurrenNum = 0;
                }
                NSLog(@"%ld",self.imageCurrenNum);
            } else if (scrollView.contentOffset.x < (self.frame.size.width * 0.5)){
                self.imageCurrenNum--;
                
                if (self.imageCurrenNum == -1) {
                    self.imageCurrenNum = self.imageTotalNum-1;
                }
                NSLog(@"%ld",self.imageCurrenNum);
            }
            if (self.imageCurrenNum == self.imageTotalNum - 1) {
                [self.imageThird sd_setImageWithURL:[NSURL URLWithString:self.dataArray[self.imageCurrenNum-1]] placeholderImage:[UIImage imageNamed:@""]];
                [self.imageSecond sd_setImageWithURL:[NSURL URLWithString:self.dataArray[0]] placeholderImage:[UIImage imageNamed:@""]];
            } else if (self.imageCurrenNum == 0) {
                [self.imageThird sd_setImageWithURL:[NSURL URLWithString:self.dataArray[self.imageTotalNum-1]] placeholderImage:[UIImage imageNamed:@""]];
                [self.imageSecond sd_setImageWithURL:[NSURL URLWithString:self.dataArray[self.imageCurrenNum+1]] placeholderImage:[UIImage imageNamed:@""]];
            } else {
                [self.imageThird sd_setImageWithURL:[NSURL URLWithString:self.dataArray[self.imageCurrenNum-1]] placeholderImage:[UIImage imageNamed:@""]];
                [self.imageSecond sd_setImageWithURL:[NSURL URLWithString:self.dataArray[self.imageCurrenNum+1]] placeholderImage:[UIImage imageNamed:@""]];
            }
            [self.imageFrist sd_setImageWithURL:[NSURL URLWithString:self.dataArray[self.imageCurrenNum]] placeholderImage:[UIImage imageNamed:@""]];
        } else {
            if (scrollView.contentOffset.x > (self.frame.size.width*1.5)) {
                self.imageCurrenNum++;
                if (self.imageCurrenNum == self.imageTotalNum) {
                    self.imageCurrenNum = 0;
                }
                NSLog(@"%ld",self.imageCurrenNum);
            } else if (scrollView.contentOffset.x < (self.frame.size.width * 0.5)){
                self.imageCurrenNum--;
                if (self.imageCurrenNum == -1) {
                    self.imageCurrenNum = 1;
                }
                NSLog(@"%ld",self.imageCurrenNum);
            }
            if (self.imageCurrenNum == self.imageTotalNum - 1) {
                [self.imageThird sd_setImageWithURL:[NSURL URLWithString:self.dataArray[0]] placeholderImage:[UIImage imageNamed:@""]];
                [self.imageSecond sd_setImageWithURL:[NSURL URLWithString:self.dataArray[0]] placeholderImage:[UIImage imageNamed:@""]];
            } else if (self.imageCurrenNum == 0) {
                [self.imageThird sd_setImageWithURL:[NSURL URLWithString:self.dataArray[1]] placeholderImage:[UIImage imageNamed:@""]];
                [self.imageSecond sd_setImageWithURL:[NSURL URLWithString:self.dataArray[1]] placeholderImage:[UIImage imageNamed:@""]];
            }
            [self.imageFrist sd_setImageWithURL:[NSURL URLWithString:self.dataArray[self.imageCurrenNum]] placeholderImage:[UIImage imageNamed:@""]];
        }
    }
    
    self.imagePageControl.currentPage = self.imageCurrenNum;
    if (scrollView.contentOffset.x > (self.frame.size.width*1.5) || scrollView.contentOffset.x < (self.frame.size.width * 0.5)) {
        scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
    
}

- (BOOL)dataIsLocalData {
    if (self.infiniteCarouselViewType == InfiniteCarouselViewTypeLocal) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setImageUserInteractionEnabled:(BOOL)imageUserInteractionEnabled {
    self.imageFrist.userInteractionEnabled = imageUserInteractionEnabled;
}




@end
