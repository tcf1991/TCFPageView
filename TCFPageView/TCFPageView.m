//
//  TCFPageView.m
//  TCFPageView
//
//  Created by 陆卫明 on 2019/9/18.
//  Copyright © 2019 tcf. All rights reserved.
//

#import "TCFPageView.h"
#import "TCFTitleView.h"
#import "TCFContentView.h"
@interface TCFPageView()<TCFTitleViewDelegate, TCFContentViewDelegata>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) TCFTitleStyle *style;
@property (nonatomic, strong) NSArray *childViewControllers;
@property (nonatomic, strong) UIViewController *parentViewController;

@property (nonatomic, weak)  TCFTitleView *titleView;
@property (nonatomic, weak)  TCFContentView *contentView;

@end

@implementation TCFPageView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(TCFTitleStyle *)style childViewControllers:(NSArray *)childViewControllers parentViewController:(UIViewController *)parentViewController {
    
    if (self = [super initWithFrame:frame]) {
        
        self.titles = titles;
        self.style = style;
        self.childViewControllers = childViewControllers;
        self.parentViewController = parentViewController;
        [self setupUI];
    }
    
    return self;
    
}



- (void)setupUI{
    
    // TitleView
    CGFloat titleViewH = 44;
    
    CGRect titleViewFrame = CGRectMake(0, 0, self.frame.size.width, titleViewH);
    
    TCFTitleView *titleView = [[TCFTitleView alloc] initWithFrame:titleViewFrame titles:self.titles style:self.style];
    self.titleView = titleView;
    [self addSubview:titleView];
    titleView.delegate = self;
    
     CGRect contentFrame = CGRectMake(0, titleViewH, self.frame.size.width, self.frame.size.height - titleViewH);
    TCFContentView *contentView = [[TCFContentView alloc] initWithFrame:contentFrame childViewControllers:self.childViewControllers parentViewController:self.parentViewController];
    self.contentView = contentView;
    contentView.delegate = self;
    

     [self addSubview:contentView];
    
    
}

#pragma mark TCFTitleViewDelegate
- (void)titleView:(TCFTitleView *)titleView selectedIndex:(NSInteger)selectedIndex {
    
    [self.contentView setCurrentIndex:(int)selectedIndex];
  
    
}

#pragma mark TCFContentViewDelegata

- (void)contentView:(TCFContentView *)contentView progress:(CGFloat)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex {
    
    [self.titleView setTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}

- (void)contentViewEndScroll:(TCFContentView *)contentView {
    
    [self.titleView contentViewDidEndScroll];
    
    
}






@end
