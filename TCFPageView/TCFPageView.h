//
//  TCFPageView.h
//  TCFPageView
//
//  Created by 陆卫明 on 2019/9/18.
//  Copyright © 2019 tcf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TCFTitleStyle;
@interface TCFPageView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(TCFTitleStyle *)style childViewControllers:(NSArray *)childViewControllers parentViewController:(UIViewController *)parentViewController;

@end

NS_ASSUME_NONNULL_END
