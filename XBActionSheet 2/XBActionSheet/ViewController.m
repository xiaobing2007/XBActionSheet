//
//  ViewController.m
//  XBActionSheet
//
//  Created by aimee on 16/8/29.
//  Copyright © 2016年 aimee. All rights reserved.
//

#import "ViewController.h"
#import "XBActionSheet.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (IBAction)demoOne:(id)sender {
    XBActionSheet *sheet = [[XBActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@[@"从相册选择",@"拍摄"] clickIndexBack:^(NSUInteger index) {
        NSLog(@"%zd", index);
    }];
    [sheet show];
    
}
- (IBAction)demoTwo:(id)sender {
    XBActionSheet *sheet = [[XBActionSheet alloc] initWithTitle:@"飞仔纸识别" cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@[@"从相册选择",@"拍摄"] clickIndexBack:^(NSUInteger index) {
        NSLog(@"%zd", index);
    }];
    [sheet show];
}
- (IBAction)demoThree:(id)sender {
    XBActionSheet *sheet = [[XBActionSheet alloc] initWithTitle:@"飞仔纸识别" cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除已选照片" otherButtonTitles:@[@"从相册选择",@"拍摄"] clickIndexBack:^(NSUInteger index) {
        NSLog(@"%zd", index);
    }];
    [sheet show];
}
- (IBAction)demoFour:(id)sender {
    XBActionSheet *sheet = [[XBActionSheet alloc] initWithTitle:@"飞仔纸识别" cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除已选照片" otherButtonTitles:@[@"从相册选择",@"拍摄"] clickIndexBack:^(NSUInteger index) {
        NSLog(@"%zd", index);
    }];
    [sheet setTitleStringFont:[UIFont systemFontOfSize:30] color:[UIColor yellowColor] backGroundColor:[UIColor purpleColor]];
    [sheet setDestructiveStringFont:[UIFont systemFontOfSize:19] color:[UIColor purpleColor] backGroundColor:nil];
    [sheet setOtherButtonTitlesStringFont:[UIFont systemFontOfSize:40] color:[UIColor blackColor] backGroundColor:[UIColor clearColor]];
    UIButton *btn = [sheet getCancelBtn];
    btn.backgroundColor = [UIColor yellowColor];

    [sheet show];

}

@end
