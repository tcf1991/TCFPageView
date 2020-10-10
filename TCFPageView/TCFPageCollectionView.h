//
//  TCFPageCollectionView.h
//  TCFPageView
//
//  Created by 陆卫明 on 2019/9/19.
//  Copyright © 2019 tcf. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class TCFPageCollectionView;
@class TCFTitleStyle;
@class TCFPageCollectionViewLayout;

@protocol TCFPageCollectionViewDataSource <NSObject>

- (NSInteger)numberOfSections:(TCFPageCollectionView *)pageCollectionView;

- (NSInteger)pageCollectionView:(TCFPageCollectionView *)pageCollectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)pageCollectionView:(TCFPageCollectionView *)pageCollectionView collectionView:(UICollectionView *)collectionView cellForItemAt:(NSIndexPath *)indexPath;


@end


@interface TCFPageCollectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(TCFTitleStyle *)style isTitleInTop:(BOOL)isTitleInTop layout:(TCFPageCollectionViewLayout *)layout;

-(void)registerClass:(nullable Class)cellClass identifier:(NSString *)identifier;
-(void)registerNib:(UINib *)nib identifier:(NSString *)identifier;




@property (nonatomic, weak) id<TCFPageCollectionViewDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
