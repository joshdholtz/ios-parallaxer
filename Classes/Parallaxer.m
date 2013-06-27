//
//  Parallaxer.m
//  Parallax
//
//  Created by Josh Holtz on 6/25/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "Parallaxer.h"

@class Parallax;

@interface Parallax : NSObject

@property (nonatomic, strong) UIView* view;
@property (nonatomic, assign) CGRect initialRect;
@property (nonatomic, assign) CGRect endRect;
@property (nonatomic, copy) ParallaxBlock block;

@end

@implementation Parallax

@end

@interface Parallaxer()

@property (nonatomic, strong) NSMutableArray *parallaxBlocks;

@end

@implementation Parallaxer

- (id)init {
    self = [super init];
    if (self) {
        _parallaxBlocks = [NSMutableArray array];
    }
    return self;
}

- (void)addParallax:(ParallaxBlock)parallaxBlock forView:(UIView*)view {
    [self addParallax:parallaxBlock forView:view startRect:view.frame endRect:CGRectZero];
}

- (void)addParallax:(ParallaxBlock)parallaxBlock forView:(UIView*)view startRect:(CGRect)startRect endRect:(CGRect)endRect {
    
    Parallax *parallax = [[Parallax alloc] init];
    [parallax setBlock:parallaxBlock];
    [parallax setInitialRect:startRect];
    [parallax setEndRect:endRect];
    [parallax setView:view];
    [_parallaxBlocks addObject:parallax];
}

// NOTE:
// If scrolling vertically, this will not keep views fixed on the "set y" position. Use method addParallaxFixedY
// If scrolling horizontally... hold on, we didn't get that far yet
- (void)addParallaxRect:(UIView *)view startRect:(CGRect)startRect endRect:(CGRect)endRect start:(float)start end:(float)end {
    [self addParallax:^(UIScrollView *scrollView, UIView *view, CGRect initialRect) {
        CGRect frame = view.frame;
        if (scrollView.contentOffset.y > start && scrollView.contentOffset.y < end) {
            float percent = 1.0f - ((end - scrollView.contentOffset.y) / (end - start));
            
            frame.origin.x = ((endRect.origin.x - initialRect.origin.x) * percent) + initialRect.origin.x;
            frame.origin.y = ((endRect.origin.y - initialRect.origin.y) * percent) + initialRect.origin.y;
            frame.size.width = ((endRect.size.width - initialRect.size.width) * percent) + initialRect.size.width;
            frame.size.height = ((endRect.size.height - initialRect.size.height) * percent) + initialRect.size.height;
            NSLog(@"X - %f, %f", percent, frame.origin.x);
            NSLog(@"Y - %f, %f", percent, frame.origin.y);
            NSLog(@"SIZE - %f, %f", percent, frame.size.width);
            NSLog(@"WIDTH - %f, %f", percent, frame.size.height);
            
        } else if (scrollView.contentOffset.y <= start) {
            frame.origin.x = initialRect.origin.x;
        } else if (scrollView.contentOffset.y >= end) {
            frame.origin.x = endRect.origin.x;
        }
        
        [view setFrame:frame];
    } forView:view startRect:startRect endRect:endRect];
}

- (void)addParallaxOutLeft:(UIView*)view start:(float)start end:(float)end {
    CGRect frame = view.frame;
    frame.origin.x = -view.superview.frame.size.width;
    [self addParallaxRect:view startRect:view.frame endRect:frame start:start end:end];
}

- (void)addParallaxInLeft:(UIView*)view start:(float)start end:(float)end {
    CGRect frame = view.frame;
    frame.origin.x = -view.superview.frame.size.width;
    [self addParallaxRect:view startRect:frame endRect:view.frame start:start end:end];
}

- (void)addParallaxOutRight:(UIView*)view start:(float)start end:(float)end {
    CGRect frame = view.frame;
    frame.origin.x = view.superview.frame.size.width;
    [self addParallaxRect:view startRect:view.frame endRect:frame start:start end:end];
}

- (void)addParallaxInRight:(UIView*)view start:(float)start end:(float)end {
    CGRect frame = view.frame;
    frame.origin.x = view.superview.frame.size.width;
    [self addParallaxRect:view startRect:frame endRect:view.frame start:start end:end];
}

- (void)addParallaxFixedY:(UIView*)view stopAt:(float)stopAt contentHeightOffset:(float)contentHeightOffset {
    [self addParallax:^(UIScrollView *scrollView, UIView *view, CGRect initialRect) {;
        if (scrollView.contentOffset.y > contentHeightOffset) {
            CGRect frame = view.frame;
            frame.origin.y = stopAt + scrollView.contentOffset.y;
            [view setFrame:frame];
        } else {
            [view setFrame:initialRect];
        }
    } forView:view];
}

- (void)addParallaxFadeOut:(UIView*)view start:(float)start end:(float)end {
    [self addParallax:^(UIScrollView *scrollView, UIView *view, CGRect initialRect) {;
        float alpha = 0.0f;
        if (scrollView.contentOffset.y > start && scrollView.contentOffset.y < end) {
            float percent = ((end - scrollView.contentOffset.y) / (end - start));
            
            alpha = percent;
            
        } else if (scrollView.contentOffset.y <= start) {
            alpha = 1.0f;
        } else if (scrollView.contentOffset.y >= end) {
            alpha = 0.0f;
        }
        
        [view setAlpha:alpha];
    } forView:view];
}

- (void)addParallaxFadeIn:(UIView*)view start:(float)start end:(float)end {
    [self addParallax:^(UIScrollView *scrollView, UIView *view, CGRect initialRect) {;
        float alpha = 0.0f;
        if (scrollView.contentOffset.y > start && scrollView.contentOffset.y < end) {
            float percent = ((end - scrollView.contentOffset.y) / (end - start));
            
            alpha = 1.0f - percent;
            
        } else if (scrollView.contentOffset.y <= start) {
            alpha = 0.0f;
        } else if (scrollView.contentOffset.y >= end) {
            alpha = 1.0f;
        }
        
        [view setAlpha:alpha];
    } forView:view];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (Parallax *parallax in _parallaxBlocks) {
        ParallaxBlock block = parallax.block;
        UIView *view = parallax.view;
        CGRect initialFrame = parallax.initialRect;
        
        block(scrollView, view, initialFrame);
    }
}

@end

