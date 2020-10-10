//
//  TCFPageCollectionViewLayout.h
//  TCFPageView
//
//  Created by 陆卫明 on 2019/9/19.
//  Copyright © 2019 tcf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCFPageCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) int cols;
@property (nonatomic, assign) int rows;

@end

NS_ASSUME_NONNULL_END
