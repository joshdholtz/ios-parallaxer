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
@property (nonatomic, copy) ParallaxBlock block;

@end

@implementation Parallax

@end

@interface Parallaxer()

@property (nonatomic, strong) NSMutableDictionary *initialFrames;
@property (nonatomic, strong) NSMutableArray *parallaxBlocks;

@end

@implementation Parallaxer

- (id)init {
    self = [super init];
    if (self) {
        _initialFrames = [NSMutableDictionary dictionary];
        _parallaxBlocks = [NSMutableArray array];
    }
    return self;
}

- (void)addParallax:(ParallaxBlock)parallaxBlock forView:(UIView*)view {
    [_initialFrames setObject:[NSValue valueWithCGRect:view.frame] forKey:[NSValue valueWithNonretainedObject:view]];
    
    Parallax *parallax = [[Parallax alloc] init];
    [parallax setBlock:parallaxBlock];
    [parallax setView:view];
    [_parallaxBlocks addObject:parallax];
}

- (void)addParallaxOutLeft:(UIView*)view start:(float)start end:(float)end {
    [self addParallax:^(UIScrollView *scrollView, UIView *view, CGRect initialRect) {
        CGRect frame = view.frame;
        if (scrollView.contentOffset.y > start && scrollView.contentOffset.y < end) {
            float percent = ((end - scrollView.contentOffset.y) / (end - start));
            NSLog(@"Percent - %f, %f", percent, scrollView.contentOffset.y);
            
            frame.origin.x = ((initialRect.origin.x + view.superview.frame.size.width) * percent) - view.superview.frame.size.width;
            
        } else if (scrollView.contentOffset.y <= start) {
            frame.origin.x = initialRect.origin.x;
        } else if (scrollView.contentOffset.y >= end) {
            frame.origin.x = view.superview.frame.size.width;
        }
        
        [view setFrame:frame];
    } forView:view];
}

- (void)addParallaxFixed:(UIView*)view stopAt:(float)stopAt contentHeightOffset:(float)contentHeightOffset {
    [self addParallax:^(UIScrollView *scrollView, UIView *view, CGRect initialRect) {;
        if (scrollView.contentOffset.y > contentHeightOffset) {
            CGRect frame = view.frame;
            frame.origin.y = stopAt + scrollView.contentOffset.y;
            [view setFrame:frame];
        }
    } forView:view];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (Parallax *parallax in _parallaxBlocks) {
        ParallaxBlock block = parallax.block;
        UIView *view = parallax.view;
        CGRect initialFrame = [[_initialFrames objectForKey:[NSValue valueWithNonretainedObject:view]] CGRectValue];
        
        block(scrollView, view, initialFrame);
    }
}

@end

