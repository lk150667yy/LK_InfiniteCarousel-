//
//  LK_InfiniteCarouselView.h
//  LK_InfiniteCarousel
//
//  Created by zhys_lk on 2018/6/26.
//  Copyright © 2018年 zhys_lk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, InfiniteCarouselViewType) {
    InfiniteCarouselViewTypeLocal, // 本地数据
    InfiniteCarouselViewTypeNetwork, // 网络请求数据
};

typedef void(^infiniteCarouselViewClickBlock)(NSInteger clickNum);

@protocol InfiniteCarouselViewDelegate<NSObject>

@optional
- (void)infiniteCarouselViewClickMethod:(NSInteger)clickNum;

@end

@interface LK_InfiniteCarouselView : UIView

/**
 图片是否可以交互 默认为:NO
 */
@property(assign, nonatomic) BOOL imageUserInteractionEnabled;

/**
 如果图片需要交互，需实现代理或block其中一个即可，返回点击图片的数组的下标
 */
@property(weak, nonatomic) id<InfiniteCarouselViewDelegate> delegate;
@property(copy, nonatomic) infiniteCarouselViewClickBlock infiniteCarouselViewClickB;

/**
 数据类型
 */
@property(assign, nonatomic)InfiniteCarouselViewType infiniteCarouselViewType;
- (instancetype)initWithFrame:(CGRect)frame withInfiniteCarouselViewType:(InfiniteCarouselViewType)icvType withImageData:(NSArray *)dataArray;
@end
