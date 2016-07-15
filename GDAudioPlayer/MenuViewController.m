//
//  MenuViewController.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/12.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "MenuViewController.h"
#import "GDPresentTransition.h"
#import "GetMusicUrlManager.h"
#define BHLOOPBTNTAG 1000
#define BHCLEARBTNTAG 1001
@interface MenuViewController ()<UIViewControllerTransitioningDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *bottomHead_Label;
@property (nonatomic, strong) UIButton *bottomHead_loopButton;
@property (nonatomic, strong) UIButton *bottomHead_clearButton;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MenuViewController
- (void)dealloc {
    
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAndDismissMenu:)];
    [self.topView addGestureRecognizer:tap];
    
    [self.bottomView addSubview:self.tableView];
    [self getDataSource];
    [self bottomHeadView];
    
}
- (void)getDataSource{
    [[PlayListSQL shareInstance] createPlaylistSQL];
    NSArray *array = [[PlayListSQL shareInstance] SQL_getPlaylist_FromDB];
    
    _dataArray = [NSMutableArray arrayWithArray:array];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}
#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
    }
    for (id object in cell.subviews) {
        [object removeFromSuperview];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, SCREENWIDTH-15, 0.5)];
    line.backgroundColor = [UIColor whiteColor];
    [cell addSubview:line];
    
    NSDictionary *dic = _dataArray[indexPath.row];
    UILabel *mname = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 24)];
    mname.text = dic[@"mname"];
    mname.font = [UIFont systemFontOfSize:15];
    mname.textColor = XUIColor(0xffffff, 0.9);
    [cell addSubview:mname];
    
    UILabel *msinger = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 150, 17)];
    msinger.text = dic[@"msinger"];
    msinger.textColor = XUIColor(0xededed, 0.9);
    msinger.font = [UIFont systemFontOfSize:13];
    [cell addSubview:msinger];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(SCREENWIDTH-(40+10), 0, 44, 44);
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [deleteBtn setTitleColor:XUIColor(0xffffff, 0.7) forState:UIControlStateNormal];
    deleteBtn.tag = indexPath.row;
    [deleteBtn addTarget:self action:@selector(deleteOneMusicyouwant:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:deleteBtn];

    return cell;
    
}
- (void)deleteOneMusicyouwant:(UIButton *)sender {
    
    NSDictionary *dic = _dataArray[sender.tag];
    NSString *mid = dic[@"mid"];
    //删除
    [[PlayListSQL shareInstance] createPlaylistSQL];
    [[PlayListSQL shareInstance] delete_MusicWhereMid:mid];
    [self getDataSource];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _dataArray[indexPath.row];
    [[GetMusicUrlManager shareInstance] getlistenMusicURL:[NSString stringWithFormat:@"%@",dic[@"mid"]] Singer:dic[@"msinger"] Album:dic[@"malbum"]];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - 播放队列，循环模式，清空按钮
- (void)bottomHeadView {
    
    [_bottomView addSubview:self.bottomHead_Label];
    [self.bottomView addSubview:self.bottomHead_loopButton];
    [self.bottomView addSubview:self.bottomHead_clearButton];
    NSNumber *loopmodel = UserDefault(Menu_LoopModel);
    NSString *lbtitle;
    if (loopmodel == [NSNumber numberWithInteger:MenuLoopType_RANDOM]){
        self.bottomHead_Label.text = [NSString stringWithFormat:@"随机播放队列(%d首)",(int)_dataArray.count];
        lbtitle = @"随机";
    }else if (loopmodel==[NSNumber numberWithInteger:MenuLoopType_SEQUENCE]){
        self.bottomHead_Label.text = [NSString stringWithFormat:@"顺序播放队列(%d首)",(int)_dataArray.count];
        lbtitle = @"顺序";
    }else if (loopmodel==[NSNumber numberWithInteger:MenuLoopType_SINGLE]){
        self.bottomHead_Label.text = @"单曲循环播放队列";
        lbtitle = @"单曲";
    }else if(loopmodel==[NSNumber numberWithInteger:MenuLoopType_ALL]||!loopmodel){
        self.bottomHead_Label.text = [NSString stringWithFormat:@"循环播放队列(%d首)",(int)_dataArray.count];
        lbtitle = @"循环";
    }
    [self.bottomHead_loopButton setTitle:lbtitle forState:UIControlStateNormal];
    
    
}
#pragma mark  - 按钮
- (void)menuBtnClick:(UIButton *)sender {
    
    if (sender.tag == BHCLEARBTNTAG) {
        
        [[PlayListSQL shareInstance]createPlaylistSQL];
        [[PlayListSQL shareInstance] delete_playlistdata];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if (sender.tag == BHLOOPBTNTAG){
        NSNumber *loopmodel = UserDefault(Menu_LoopModel);
        NSInteger changeModel;NSString *title;
        if (loopmodel == [NSNumber numberWithInteger:MenuLoopType_RANDOM]){
            title = @"顺序";
            self.bottomHead_Label.text = [NSString stringWithFormat:@"顺序播放队列(%d首)",(int)_dataArray.count];
            changeModel = MenuLoopType_SEQUENCE;
        }else if (loopmodel==[NSNumber numberWithInteger:MenuLoopType_SEQUENCE]){
            self.bottomHead_Label.text = @"单曲循环播放队列";
            title = @"单曲";
            changeModel = MenuLoopType_SINGLE;
        }else if (loopmodel==[NSNumber numberWithInteger:MenuLoopType_SINGLE]){
            self.bottomHead_Label.text = [NSString stringWithFormat:@"循环播放队列(%d首)",(int)_dataArray.count];
            title = @"循环";
            changeModel = MenuLoopType_ALL;
        }else if(loopmodel==[NSNumber numberWithInteger:MenuLoopType_ALL]||!loopmodel){
            self.bottomHead_Label.text = [NSString stringWithFormat:@"随机播放队列(%d首)",(int)_dataArray.count];
            title = @"随机";
            changeModel = MenuLoopType_RANDOM;
        }
        UD_SetValue([NSNumber numberWithInteger:changeModel], Menu_LoopModel);
        [self.bottomHead_loopButton setTitle:title forState:UIControlStateNormal];
        
    }
    
}
- (void)tapViewAndDismissMenu:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 懒加载
- (UIButton *)bottomHead_clearButton{
    if (!_bottomHead_clearButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREENWIDTH-(40+10), 0, 44, 44);
        button.tag = BHCLEARBTNTAG;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"清空" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _bottomHead_clearButton = button;
    }
    return _bottomHead_clearButton;
}
- (UIButton *)bottomHead_loopButton{
    if (!_bottomHead_loopButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREENWIDTH-(44*2+10), 0, 44, 44);
        button.tag = BHLOOPBTNTAG;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _bottomHead_loopButton = button;
    }
    return _bottomHead_loopButton;
}
- (UILabel *)bottomHead_Label{
    if (!_bottomHead_Label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 145, 44)];
        label.textColor = XUIColor(0xffffff, 1);
        label.font = [UIFont systemFontOfSize:15];
        _bottomHead_Label = label;
    }
    return _bottomHead_Label;
}
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44.5, SCREENWIDTH, 205.5)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
    }
    return _tableView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-250, SCREENWIDTH, 250)];
        view.backgroundColor = XUIColor(0x000000, 0.8);
        view.userInteractionEnabled = YES;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 44, SCREENWIDTH-20, 0.5)];
        line.backgroundColor = [UIColor whiteColor];
        [view addSubview:line];
        _bottomView = view;
    }
    return _bottomView;
}
- (UIView *)topView {
    if (!_topView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-250)];
        view.userInteractionEnabled = YES;
        _topView = view;
    }
    return _topView;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.15 animations:^{
        self.topView.backgroundColor = XUIColor(0x000000, 0.1);
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.topView.backgroundColor = [UIColor clearColor];
}

#pragma mark - 转场动画代理
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    //这里我们初始化presentType
    return [[GDPresentTransition shareInstance] initWithTransitionType:GDPresentOneTransitionTypePresent];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    return [[GDPresentTransition shareInstance] initWithTransitionType:GDPresentOneTransitionTypeDismiss];
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
