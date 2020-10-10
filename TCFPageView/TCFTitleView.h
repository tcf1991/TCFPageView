//
//  TCFTitleView.h
//  TCFPageView
//
//  Created by 陆卫明 on 2019/9/18.
//  Copyright © 2019 tcf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCFTitleStyle;
@class TCFTitleView;
NS_ASSUME_NONNULL_BEGIN

@protocol TCFTitleViewDelegate <NSObject>

- (void)titleView:(TCFTitleView *)titleView selectedIndex:(NSInteger)selectedIndex;

@end

@interface TCFTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(TCFTitleStyle *)style;

//对外暴露的方法
- (void)contentViewDidEndScroll;

- (void)setTitleWithProgress:(CGFloat)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex;

@property (nonatomic, weak)  id<TCFTitleViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
