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
- (void)addParallaxOutLeft:(UIView*)view start:(float)start end:(float)end;
- (void)addParallaxFixed:(UIView*)view stopAt:(float)stopAt contentHeightOffset:(float)contentHeightOffset;

- (void)scrollViewDidScroll:(UIScrollView*)scrollView;

@end
