//
//  TCFTitleView.m
//  TCFPageView
//
//  Created by 陆卫明 on 2019/9/18.
//  Copyright © 2019 tcf. All rights reserved.
//

#import "TCFTitleView.h"
#import "TCFTitleStyle.h"
@interface TCFTitleView()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) TCFTitleStyle *style;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *splitLineView;
@property (nonatomic, strong) NSMutableArray *titleLabels;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UIView *coverView;


@end

@implementation TCFTitleView

- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.bounds;
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}
- (NSArray *)titleLabels {
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (UIView *)splitLineView {
    if (_splitLineView == nil) {
       _splitLineView = [[UIView alloc] init];
        CGFloat height = 0.5;
        _splitLineView.backgroundColor = [UIColor lightGrayColor];
        _splitLineView.frame = CGRectMake(0, self.frame.size.height - height, self.frame.size.width, height);
       
    }
    return _splitLineView;
}

- (UIView *)bottomLine {
    
    if (_bottomLine == nil) {
       _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = self.style.bottomLineColor;
    }
    return _bottomLine;
}

- (UIView *)coverView {
    if (_coverView == nil) {
       _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = self.style.coverBgColor;
        _coverView.alpha = 0.7;
       
    }
    return _coverView;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(TCFTitleStyle *)style {
    
    if (self = [super initWithFrame:frame]) {
        
        self.titles = titles;
        self.style = style;
        
        self.currentIndex = 0;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
     // 1.添加Scrollview
    [self addSubview:self.scrollView];
     // 2.添加底部分割线
    [self addSubview:self.splitLineView];
    //  3.设置所有的标题Label
    [self setupTitleLabels];
    //4.设置Label的位置
    [self setupTitleLabelsPosition];
    // 5.设置底部的滚动条
    if (self.style.isShowBottomLine) {
        
        [self setupBottomLine];
    }
    // 6.设置遮盖的View
    if (self.style.isShowCover) {
        [self setupCoverView];
    }
    
    
    
    
    
}
- (void)setupTitleLabels {
    
    NSArray *titles = self.titles;
    for (int i = 0; i <titles.count; i++) {
        UILabel *lable = [[UILabel alloc] init];
        lable.tag = i;
        lable.text = titles[i];
        lable.textColor = i == 0 ? self.style.selectedColor : self.style.normalColor;
        lable.font = self.style.font;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [lable addGestureRecognizer:tap];
        
        [self.titleLabels addObject:lable];
        [self.scrollView addSubview:lable];
        
    }
    
}

- (void)setupBottomLine {
    
    [self.scrollView addSubview:self.bottomLine];
    UILabel *firstLabel = self.titleLabels.firstObject;
    
    CGRect rect = firstLabel.frame;

    rect.size.height = self.style.bottomLineH;
    rect.origin.y = self.bounds.size.height - self.style.bottomLineH;
    _bottomLine.frame = rect;
    
}

- (void)setupCoverView {
    [self.scrollView insertSubview:self.coverView atIndex:0];
    UILabel *firstLabel = self.titleLabels[0];
    CGFloat coverW = firstLabel.frame.size.width;
    CGFloat coverH = self.style.coverH;
    CGFloat coverX = firstLabel.frame.origin.x;
    CGFloat coverY = (self.bounds.size.height - coverH) * 0.5;
    
    if (self.style.isScrollEnable) {
        coverX -= self.style.coverMargin;
        coverW += self.style.coverMargin * 2;
    }
    
    _coverView.frame = CGRectMake(coverX, coverY, coverW, coverH);
    _coverView.layer.cornerRadius = self.style.coverRadius;
    _coverView.layer.masksToBounds = YES;
    
    
}

-(void)setupTitleLabelsPosition {
    
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = 0;
    CGFloat titleH = self.frame.size.height;
    
    NSUInteger count = self.titles.count;
    
    for (int i = 0; i< count; i ++) {
        UILabel *label = self.titleLabels[i];
        if (self.style.isScrollEnable) {
            
            CGRect rect = [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.style.font} context:nil];
            titleW = rect.size.width;
            if (i == 0) {
                titleX = self.style.titleMargin * 0.5;
            }else {
                UILabel *preLabel = self.titleLabels[i - 1];
                titleX = CGRectGetMaxX(preLabel.frame) + self.style.titleMargin;
            }
            
        }else {
            titleW = self.frame.size.width / count;
            titleX = titleW * i;
        }
        
        label.frame = CGRectMake(titleX, titleY, titleW, titleH);
        
        if (i == 0) {
            CGFloat scale = self.style.isNeedScale ? self.style.scaleRange : 1.0;
            label.transform = CGAffineTransformMakeScale(scale, scale);
            
        }
        
        if (self.style.isScrollEnable) {
            UILabel *lastLabel = self.titleLabels.lastObject;
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame) + self.style.titleMargin * 0.5, 0);
        }
        
    }
}

#pragma mark titleLabelClick
-(void)titleLabelClick:(UITapGestureRecognizer *)tap {
    UILabel *currentLabel = (UILabel *)tap.view;
       // 1.如果是重复点击同一个Title,那么直接返回
    if (currentLabel.tag == self.currentIndex) return;
    
      //2.获取之前的Label
    UILabel *oldLabel = self.titleLabels[_currentIndex];
    // 3.切换文字的颜色
    currentLabel.textColor = self.style.selectedColor;
    oldLabel.textColor = self.style.normalColor;
    // 4.保存最新Label的下标值
    _currentIndex = currentLabel.tag;
    
     // 5.通知代理
    
    if ([self.delegate respondsToSelector:@selector(titleView:selectedIndex:)]) {
        
        [self.delegate titleView:self selectedIndex:_currentIndex];
        
    }
    
     // 6.居中显示
    [self contentViewDidEndScroll];
    // 7.调整bottomLine
    
    if (self.style.isShowBottomLine) {
        [UIView animateWithDuration:0.15 animations:^{
            
            CGRect rect = self.bottomLine.frame;
            
            rect.origin.x = currentLabel.frame.origin.x;
            rect.size.width = currentLabel.frame.size.width;
            self.bottomLine.frame = rect;

        }];
    }
      // 8.调整比例
    
    if (self.style.isNeedScale) {
        oldLabel.transform = CGAffineTransformIdentity;
        currentLabel.transform = CGAffineTransformMakeScale(self.style.scaleRange, self.style.scaleRange);
    }
    
     // 9.遮盖移动
    if (self.style.isShowCover) {
        
        CGFloat coverX = self.style.isScrollEnable ? (currentLabel.frame.origin.x - self.style.coverMargin) : currentLabel.frame.origin.x;
        
        CGFloat coverW = self.style.isScrollEnable ? (currentLabel.frame.size.width + self.style.coverMargin * 2) : currentLabel.frame.size.width;
        
        [UIView animateWithDuration:0.15 animations:^{
            
            CGRect rect = self.coverView.frame;
            
            rect.origin.x = coverX;
            rect.size.width = coverW;
            
            self.coverView.frame = rect;
            
        }];
        
    }
    
    
    
    
}
- (void)contentViewDidEndScroll {
      // 0.如果是不需要滚动,则不需要调整中间位置
    if (!self.style.isScrollEnable) return;
     // 1.获取获取目标的Label
    UILabel *targetLabel = self.titleLabels[_currentIndex];
       // 2.计算和中间位置的偏移量
    
    CGFloat offSetX = targetLabel.center.x - self.bounds.size.width * 0.5;
    
    if (offSetX < 0) {
        offSetX = 0;
    }
    CGFloat maxOffset = self.scrollView.contentSize.width - self.bounds.size.width;
    
    if (offSetX > maxOffset) {
        offSetX = maxOffset;
    }
    
    [self.scrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    
    
}

- (void)setTitleWithProgress:(CGFloat)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex {
    
    // 1.取出sourceLabel/targetLabel
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
     // 3.颜色的渐变(复杂)
     // 3.1.取出变化的范围
    
    CGFloat selectedR = 0.0,selectedG = 0.0,selectedB = 0.0;
    
    CGFloat normalR = 0.0,normalG = 0.0,normalB = 0.0;
    
    [self.style.selectedColor getRed:&selectedR green:&selectedG blue:&selectedB alpha:NULL];
    
    [self.style.normalColor getRed:&normalR green:&normalG blue:&normalB alpha:NULL];
    
    CGFloat colorDeltaR = selectedR - normalR;
    CGFloat colorDeltaG = selectedG - normalG;
    CGFloat colorDeltaB = selectedB - normalB;
    
    // 变化sourceLabel

    sourceLabel.textColor = [UIColor colorWithRed:(selectedR - colorDeltaR * progress)  green:(selectedG - colorDeltaG * progress)  blue:(selectedB - colorDeltaB * progress)  alpha:1.0];
    
    //变化targetLabel

    targetLabel.textColor = [UIColor colorWithRed:(normalR + colorDeltaR * progress)  green:(normalG + colorDeltaG * progress) blue:(normalB + colorDeltaB * progress)  alpha:1.0];
    
    // 4.记录最新的index
    self.currentIndex = targetIndex;
    
    CGFloat moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    CGFloat moveTotalW = targetLabel.frame.size.width - sourceLabel.frame.size.width;
     // 5.计算滚动的范围差值
    if (self.style.isShowBottomLine) {
        
        CGRect rect = self.bottomLine.frame;
        rect.size.width = sourceLabel.frame.size.width + moveTotalW * progress;
        rect.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress;
        self.bottomLine.frame = rect;
      
    }
    
     // 6.放大的比例
    if (self.style.isNeedScale) {
        CGFloat scaleDelta = (self.style.scaleRange - 1.0) * progress;
        
        sourceLabel.transform = CGAffineTransformMakeScale(self.style.scaleRange - scaleDelta, self.style.scaleRange - scaleDelta);
        
         targetLabel.transform = CGAffineTransformMakeScale(1 + scaleDelta, 1 + scaleDelta);
    }
    
     // 7.计算cover的滚动
    if (self.style.isShowCover) {
        
        CGRect rect = self.coverView.frame;
        rect.size.width = self.style.isScrollEnable ? (sourceLabel.frame.size.width + 2 * self.style.coverMargin + moveTotalW * progress) : (sourceLabel.frame.size.width + moveTotalW * progress);
        
        rect.origin.x = self.style.isScrollEnable ? (sourceLabel.frame.origin.x - self.style.coverMargin + moveTotalX * progress ): (sourceLabel.frame.origin.x + moveTotalX * progress);
        
        self.coverView.frame = rect;
        
        
    }
    
    
    
}

@end
