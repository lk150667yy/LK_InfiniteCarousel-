//
//  ViewController.m
//  LK_InfiniteCarousel
//
//  Created by zhys_lk on 2018/6/26.
//  Copyright © 2018年 zhys_lk. All rights reserved.
//

#import "ViewController.h"
#import "LK_InfiniteCarouselView.h"
#import "RandomView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LK_InfiniteCarouselView *icV = [[LK_InfiniteCarouselView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) withInfiniteCarouselViewType:InfiniteCarouselViewTypeLocal withImageData:nil];
    icV.imageUserInteractionEnabled = YES;
    icV.infiniteCarouselViewClickB = ^(NSInteger clickNum) {
        self.showLabel.text = [NSString stringWithFormat:@"%ld",clickNum];
    };
    [self.view addSubview:icV];
//
//    RandomView *v = [[RandomView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:v];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
