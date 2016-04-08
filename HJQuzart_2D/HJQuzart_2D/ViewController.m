//
//  ViewController.m
//  HJQuzart_2D
//
//  Created by coco on 16/3/30.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "ViewController.h"
#import "CGPathView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGPathView *pathView = [[CGPathView alloc] initWithFrame:self.view.bounds];
    pathView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pathView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
