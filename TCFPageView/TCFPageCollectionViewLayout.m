//
//  TCFPageCollectionViewLayout.m
//  TCFPageView
//
//  Created by 陆卫明 on 2019/9/19.
//  Copyright © 2019 tcf. All rights reserved.
//

#import "TCFPageCollectionViewLayout.h"

@interface TCFPageCollectionViewLayout()

@property (nonatomic, strong) NSMutableArray *cellAttrs;
@property (nonatomic, assign) CGFloat maxWidth;

@end
@implementation TCFPageCollectionViewLayout


- (NSMutableArray *)cellAttrs {
    if (_cellAttrs == nil) {
        _cellAttrs = [NSMutableArray array];
    }
    return _cellAttrs;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
       
        self.cols = 4;
        self.rows = 2;
        self.maxWidth = 0;
        
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
       // 0.计算item宽度&高度
    CGFloat itemW = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing * (self.cols - 1)) / self.cols;
    
    CGFloat itemH = (self.collectionView.bounds.size.height - self.sectionInset.top - self.sectionInset.bottom - self.minimumLineSpacing * (self.rows - 1)) / self.rows;
    
     // 1.获取一共多少组
    NSInteger sectionCount = self.collectionView.numberOfSections;
    
    int prePageCount = 0;
    for (int i = 0; i < sectionCount; i++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j< itemCount; j ++) {
           // 2.1.获取Cell对应的indexPath
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            
            // 2.2.根据indexPath创建UICollectionViewLayoutAttributes
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            // 2.3.计算j在该组中第几页
            
            int page = j / (self.cols * self.rows);
            int index = j % (self.cols * self.rows);
             // 2.3.设置attr的frame
            CGFloat itemY = self.sectionInset.top + (itemH + self.minimumLineSpacing) * (index / self.cols);
            CGFloat itemX = (prePageCount + page) * self.collectionView.bounds.size.width + self.sectionInset.left + (itemW + self.minimumInteritemSpacing) * (index % self.cols);
            
            attr.frame = CGRectMake(itemX, itemY, itemW, itemH);
              // 2.4.保存attr到数组中
            [self.cellAttrs addObject:attr];
            
        }
        prePageCount += (itemCount - 1) / (self.rows * self.cols) + 1;
    }
     // 3.计算最大Y值
    self.maxWidth = prePageCount * self.collectionView.bounds.size.width;
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.cellAttrs;
    
}

- (CGSize)collectionViewContentSize {
    
    return CGSizeMake(self.maxWidth, 0);
    
}
@end
