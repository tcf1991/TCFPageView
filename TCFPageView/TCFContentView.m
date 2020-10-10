//
//  TCFContentView.m
//  TCFPageView
//
//  Created by 陆卫明 on 2019/9/18.
//  Copyright © 2019 tcf. All rights reserved.
//

#import "TCFContentView.h"

@interface TCFContentView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *childViewControllers;
@property (nonatomic, strong) UIViewController *parentViewController;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isForbidScrollDelegate;
@property (nonatomic, assign) CGFloat startOffsetX;

@end

@implementation TCFContentView
static NSString *const kContentCellID = @"kContentCellID";

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.scrollsToTop = NO;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.frame = self.bounds;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kContentCellID];
        
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame childViewControllers:(NSArray *)childViewControllers parentViewController:(UIViewController *)parentViewController {
    
    if (self = [super initWithFrame:frame]) {
        
        self.childViewControllers = childViewControllers;
        self.parentViewController = parentViewController;
        self.isForbidScrollDelegate = NO;
        self.startOffsetX = 0;
        
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI {
     // 1.将所有的控制器添加到父控制器中
    
    for (UIViewController *vc in self.childViewControllers) {
        
        [self.parentViewController addChildViewController:vc];
    }
    
    [self addSubview:self.collectionView];
    
    
}

#pragma mark 设置UICollectionView的数据源

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kContentCellID forIndexPath:indexPath];
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIViewController *childVc = self.childViewControllers[indexPath.item];
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
    return cell;
    
}

#pragma mark 设置UICollectionView的代理

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.isForbidScrollDelegate = NO;
    self.startOffsetX = scrollView.contentOffset.x;
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([self.delegate respondsToSelector:@selector(contentViewEndScroll:)]) {
        [self.delegate contentViewEndScroll:self];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(contentViewEndScroll:)]) {
        [self.delegate contentViewEndScroll:self];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     // 0.判断是否是点击事件
    if (_isForbidScrollDelegate) return;
    
   
    
     // 1.定义获取需要的数据
    CGFloat progress = 0;
    int sourceIndex = 0;
    int targetIndex = 0;
     // 2.判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    
    if (currentOffsetX > self.startOffsetX) {  // 左滑
         // 1.计算progress
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        // 2.计算sourceIndex
        sourceIndex = (int)(currentOffsetX / scrollViewW);
         // 3.计算targetIndex
        targetIndex = sourceIndex + 1;
        if (targetIndex >= self.childViewControllers.count) {
            targetIndex = (int)(self.childViewControllers.count - 1);
        }
        
         // 4.如果完全划过去
        if ((currentOffsetX - self.startOffsetX) == scrollViewW) {
            progress = 1;
            targetIndex = sourceIndex;
        }
        
    }else {  // 右滑
         // 1.计算progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
          // 2.计算targetIndex
        targetIndex = (int)(currentOffsetX / scrollViewW);
         // 3.计算sourceIndex
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childViewControllers.count) {
            sourceIndex = (int)(self.childViewControllers.count - 1);
        }
    }
    
    // 3.将progress/sourceIndex/targetIndex传递给titleView
    if ([self.delegate respondsToSelector:@selector(contentView:progress:sourceIndex:targetIndex:)]) {
        
        [self.delegate contentView:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
    

    
}
- (void)setCurrentIndex:(int)currentIndex {
     // 1.记录需要进制执行代理方法
    self.isForbidScrollDelegate = YES;
     // 2.滚动正确的位置
    CGFloat offsetX = currentIndex * self.collectionView.frame.size.width;
    
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    
}

@end
