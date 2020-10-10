//
//  TCFContentView.h
//  TCFPageView
//
//  Created by 陆卫明 on 2019/9/18.
//  Copyright © 2019 tcf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TCFContentView;
@protocol TCFContentViewDelegata <NSObject>

-(void)contentView:(TCFContentView *)contentView progress:(CGFloat)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex;
@optional
-(void)contentViewEndScroll:(TCFContentView *)contentView;

@end
@interface TCFContentView : UIView

- (instancetype)initWithFrame:(CGRect)frame childViewControllers:(NSArray *)childViewControllers parentViewController:(UIViewController *)parentViewController;

- (void)setCurrentIndex:(int)currentIndex;

@property (nonatomic, weak) id<TCFContentViewDelegata> delegate;

@end

NS_ASSUME_NONNULL_END
