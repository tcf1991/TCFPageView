//
//  TCFTitleStyle.m
//  TCFPageView
//
//  Created by 陆卫明 on 2019/9/18.
//  Copyright © 2019 tcf. All rights reserved.
//

#import "TCFTitleStyle.h"

#define TCFRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0];
@implementation TCFTitleStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.isScrollEnable = NO;
        self.normalColor = TCFRGB(0, 0, 0);
        self.selectedColor = TCFRGB(255, 127, 0);
        self.font = [UIFont systemFontOfSize:14.0];
        self.titleMargin = 20;
        self.titleHeight = 44;
        self.isShowBottomLine = NO;
        self.bottomLineColor = [UIColor orangeColor];
        self.bottomLineH = 2;
        self.isNeedScale = NO;
        self.scaleRange = 1.2;
        
        self.isShowCover = NO;
        self.coverBgColor = [UIColor lightGrayColor];
        self.coverMargin = 5;
        self.coverH = 25;
        self.coverRadius = 4;
        
    }
    return self;
}

@end
