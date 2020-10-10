//
//  TCFPageCollectionView.m
//  TCFPageView
//
//  Created by 陆卫明 on 2019/9/19.
//  Copyright © 2019 tcf. All rights reserved.
//

#import "TCFPageCollectionView.h"
#import "TCFTitleStyle.h"
#import "TCFPageCollectionViewLayout.h"
#import "TCFTitleView.h"
@interface TCFPageCollectionView()<TCFTitleViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) TCFTitleStyle *style;
@property (nonatomic, assign) BOOL isTitleInTop;
@property (nonatomic, strong) TCFPageCollectionViewLayout *layout;

@property (nonatomic, weak) TCFTitleView *titleView;

@property (nonatomic, weak)  UIPageControl *pageControl;
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSIndexPath *sourceIndexPath;

@end

@implementation TCFPageCollectionView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(TCFTitleStyle *)style isTitleInTop:(BOOL)isTitleInTop layout:(TCFPageCollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame]) {
        
        self.titles = titles;
        self.style = style;
        self.isTitleInTop = isTitleInTop;
        self.layout = layout;
        
        [self setupUI];
        
    }
    return self;
    
    
}

- (void)setupUI {
    // 1.创建titleView
    CGFloat titleY = self.isTitleInTop ? 0 : self.frame.size.height - self.style.titleHeight;
    CGRect titleFrame = CGRectMake(0, titleY, self.bounds.size.width, self.style.titleHeight);
    
    TCFTitleView *titleView = [[TCFTitleView alloc] initWithFrame:titleFrame titles:self.titles style:self.style];
    _titleView = titleView;
    titleView.delegate = self;
    [self addSubview:titleView];
    
     // 2.创建UIPageControl
    CGFloat pageControlHeight = 20;
    CGFloat pageControlY = self.isTitleInTop ? (self.bounds.size.height - pageControlHeight) : (self.bounds.size.height - pageControlHeight - self.style.titleHeight);
    
    CGRect pageControlFrame = CGRectMake(0, pageControlY, self.bounds.size.width, pageControlHeight);
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    pageControl.numberOfPages = 4;
    pageControl.enabled = NO;
    _pageControl = pageControl;
    pageControl.backgroundColor = [UIColor grayColor];
    [self addSubview:pageControl];
    
     // 3.创建UICollectionView
    CGFloat collectionViewY = self.isTitleInTop ? self.style.titleHeight: 0;
    CGRect collectionViewFrame = CGRectMake(0, collectionViewY, self.bounds.size.width, self.bounds.size.height - self.style.titleHeight - pageControlHeight);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:self.layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView = collectionView;
    
    [self addSubview:collectionView];
    
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if ([self.dataSource respondsToSelector:@selector(numberOfSections:)]) {
        
        return [self.dataSource numberOfSections:self];
    }
    
    return 0;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(pageCollectionView:numberOfItemsInSection:)]) {
        
        NSInteger itemCount = [self.dataSource pageCollectionView:self numberOfItemsInSection:section];
        
        if (section == 0) {
            self.pageControl.numberOfPages = (itemCount - 1) / (self.layout.cols * self.layout.rows) + 1;
        }
        
        return itemCount;
        
    }
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dataSource respondsToSelector:@selector(pageCollectionView:collectionView:cellForItemAt:)]) {
        
        return [self.dataSource pageCollectionView:self collectionView:collectionView cellForItemAt:indexPath];
    }
    
    return nil;
    
}

#pragma mark UICollectionViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewEndScroll];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
         [self scrollViewEndScroll];
    }
}



- (void)scrollViewEndScroll {
    // 1.取出在屏幕中显示的Cell
    CGPoint point = CGPointMake(self.layout.sectionInset.left + 1 + self.collectionView.contentOffset.x, self.layout.sectionInset.top + 1);
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    // 2.判断分组是否有发生改变
    
    if (_sourceIndexPath.section != indexPath.section) {
        // 3.1.修改pageControl的个数
        NSInteger itemCount = [self.dataSource pageCollectionView:self numberOfItemsInSection:indexPath.section];
        self.pageControl.numberOfPages = (itemCount - 1) / (self.layout.cols * self.layout.rows) + 1;
        
        // 3.2.设置titleView位置
        
        [self.titleView setTitleWithProgress:1.0 sourceIndex:(int)(_sourceIndexPath.section) targetIndex:(int)(indexPath.section)];
         // 3.3.记录最新indexPath
        _sourceIndexPath = indexPath;
    }
    // 3.根据indexPath设置pageControl
    self.pageControl.currentPage = indexPath.item / (self.layout.rows * self.layout.cols);
    
}
#pragma mark TCFTitleViewDelegate
- (void)titleView:(TCFTitleView *)titleView selectedIndex:(NSInteger)selectedIndex {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:selectedIndex];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    CGPoint offset = self.collectionView.contentOffset;
    offset.x -= self.layout.sectionInset.left;
    self.collectionView.contentOffset = offset;
    
    [self scrollViewEndScroll];
    
  
}

- (void)registerClass:(Class)cellClass identifier:(NSString *)identifier {
    
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
    
}

- (void)registerNib:(UINib *)nib identifier:(NSString *)identifier {
    
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}


@end
