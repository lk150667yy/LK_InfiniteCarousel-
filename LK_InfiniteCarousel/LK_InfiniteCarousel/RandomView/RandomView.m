//
//  RandomView.m
//  LK_InfiniteCarousel
//
//  Created by zhys_lk on 2018/6/27.
//  Copyright © 2018年 zhys_lk. All rights reserved.
//

#import "RandomView.h"

@interface RandomView()<UITextViewDelegate>

@property(weak, nonatomic) NSTimer *ti;
@property(nonatomic, weak) UITextView *tv;
@property(strong, nonatomic) NSArray *stringArray;
@property(assign, nonatomic)NSInteger index;
@property(assign, nonatomic)BOOL isTouch;
@property(copy, nonatomic) NSString *tempString;

@end

@implementation RandomView

- (NSArray *)stringArray {
    if (!_stringArray) {
        _stringArray = @[@"",@"",@"",@""];
    }
    return _stringArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.index = 0;
        [self timer];
        [self createView];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewMethod)]];
    }
    return self;
}

- (void)timer {
    NSTimer * ti = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                    target:self selector:@selector(randomView) userInfo:nil repeats:YES];
    self.ti = ti;
}

- (void)createView {
    UITextView * tv = [[UITextView alloc] initWithFrame:CGRectMake(100,  150, self.frame.size.width -200, 100)];
    tv.hidden = YES;
    tv.delegate = self;
    tv.backgroundColor = [UIColor grayColor];
    [self addSubview:tv];
    self.tv = tv;

}

- (void)viewMethod {
    self.isTouch = !self.isTouch;
    if (self.isTouch) {
        self.tempString = @"";
        self.tv.hidden = NO;
    } else {
        [self.tv resignFirstResponder];
        self.index = 0;
        self.tv.hidden = YES;
        NSInteger num = self.tv.text.length;
        if (num > 0) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (int i= 0; i<num; i++) {
                NSRange range = NSMakeRange(i, 1);
                NSString *result = [self.tv.text substringWithRange:range];
                [tempArray addObject:result];
            }
            self.stringArray = tempArray;
        } else {
            self.stringArray = @[@""];
        }
       
//        if (self.tempString.length != 0) {
//            self.stringArray = [self.tempString componentsSeparatedByString:@","];
//        }
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if (text.length > 0) {
//        if (self.tempString.length ==0) {
//            if ([self isChinese:text]) {
//                self.tempString = text;
//            }
//        } else {
//            if ([self isChinese:text]) {
//                self.tempString = [NSString stringWithFormat:@"%@,%@",self.tempString,text];
//            }
//        }
//    }
//    return YES;
//}




- (void)randomView {
    
    
    //    if (self.stringArray.count > 0) {
    CGFloat widthAndHeight = 30;
    CGFloat y = -40;
    int num = (int)self.frame.size.width-30;
    int xxNum = arc4random()%5;
    CGFloat x = arc4random()%num;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:self.stringArray[self.index] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.frame = CGRectMake(x, y, widthAndHeight, widthAndHeight);
    [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"xx_%d",xxNum]] forState:UIControlStateNormal];
    [self addSubview:btn];
    self.index++;
    if (self.index == self.stringArray.count) {
        self.index = 0;
    }
    [UIView animateWithDuration:10 animations:^{
        btn.frame = CGRectMake(x, self.frame.size.height, widthAndHeight, widthAndHeight);
    } completion:^(BOOL finished) {
        [btn removeFromSuperview];
    }];
    //    }
    
    
    
}

- (BOOL)isChinese:(NSString *)text {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:text];
    
}

@end
