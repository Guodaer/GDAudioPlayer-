//
//  AudioPlayDetailVC.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/12.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "AudioPlayDetailVC.h"

@interface AudioPlayDetailVC ()

@end

@implementation AudioPlayDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:self.view.frame];
    imgview.image = XUIImage(@"side_bg");
    [self.view addSubview:imgview];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, 35, 40, 40);
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [button setImage:XUIImage(@"tabbar_audio_next_normal") forState:UIControlStateNormal];
    [button setImage:XUIImage(@"tabbar_audio_next_highlight") forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(dismissVC:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)dismissVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
