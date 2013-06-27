//
//  Parallaxer.h
//  Parallax
//
//  Created by Josh Holtz on 6/25/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ParallaxBlock)(UIScrollView* scrollView, UIView *view, CGRect initialRect);

@interface Parallaxer : NSObject

- (void)addParallax:(ParallaxBlock)parallaxBlock forView:(UIView*)view;
- (void)addParallax:(ParallaxBlock)parallaxBlock forView:(UIView*)view startRect:(CGRect)startRect endRect:(CGRect)endRect;

- (void)addParallaxRect:(UIView *)view startRect:(CGRect)startRect endRect:(CGRect)endRect start:(float)start end:(float)end;

- (void)addParallaxOutLeft:(UIView*)view start:(float)start end:(float)end;
- (void)addParallaxInLeft:(UIView*)view start:(float)start end:(float)end;

- (void)addParallaxOutRight:(UIView*)view start:(float)start end:(float)end;
- (void)addParallaxInRight:(UIView*)view start:(float)start end:(float)end;

- (void)addParallaxFixedY:(UIView*)view stopAt:(float)stopAt contentHeightOffset:(float)contentHeightOffset;

- (void)addParallaxFadeOut:(UIView*)view start:(float)start end:(float)end;
- (void)addParallaxFadeIn:(UIView*)view start:(float)start end:(float)end;

- (void)scrollViewDidScroll:(UIScrollView*)scrollView;

@end
