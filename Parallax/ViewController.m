//
//  ViewController.m
//  Parallax
//
//  Created by Josh Holtz on 6/25/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "ViewController.h"

#import "Parallaxer.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) Parallaxer *parallaxer;
@property (nonatomic, strong) UIView *viewScrollViewContent;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ScrollContentView" owner:self options:nil];
    _viewScrollViewContent = [nibContents objectAtIndex:0];
    [_scrollView addSubview: _viewScrollViewContent];
    [_scrollView setContentSize:CGSizeMake(_viewScrollViewContent.frame.size.width, _viewScrollViewContent.frame.size.height)];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_parallaxer == nil) {
        _parallaxer = [[Parallaxer alloc] init];
        
        [_parallaxer addParallaxFixed:_view1 stopAt:0 contentHeightOffset:0];
        [_parallaxer addParallaxFixed:_view2 stopAt:50 contentHeightOffset:50];
        [_parallaxer addParallaxFixed:_view3 stopAt:100 contentHeightOffset:150];
        [_parallaxer addParallaxFixed:_view4 stopAt:100 contentHeightOffset:350];
        
        [_parallaxer addParallaxOutLeft:_view3 start:200 end:350];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_parallaxer scrollViewDidScroll:scrollView];
}

@end
