//
//  MusicDetailVController.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/12.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "MusicDetailVController.h"
#import "GDTensionView.h"
#import "MDCell.h"
@interface MusicDetailVController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GDTensionView *tensionView;

@property (nonatomic, strong) UILabel *interestLabel;
@end

@implementation MusicDetailVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgimageView.image = XUIImage(@"side_bg1");
    [self.view addSubview:bgimageView];

    NSLog(@"%@",_needModel.maname);
    
    [self createMainUI];

}
- (void)createMainUI {
    
    _interestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, SCREENWIDTH, 30)];
    _interestLabel.text = @"别拉了，到头了";
    _interestLabel.textColor = XUIColor(0xffffff, 0.8);
    _interestLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_interestLabel];
    _interestLabel.hidden = YES;
    CGFloat height;
    height = SCREENWIDTH*528/2/540;
    self.tensionView = [[GDTensionView alloc] initWithFrame:CGRectMake(0, 65, SCREENWIDTH, height) WithImages:[NSURL URLWithString:_needModel.mashow_b] PlaceholderImage:nil];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MDCell class] forCellReuseIdentifier:@"cell"];

    self.tableView.tableHeaderView = self.tensionView;
    
    [self musicDetaildownloadDatas];

    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < -1) {
        if (offsetY > -50) {
            //修改本地
            [self.tensionView imageViewStretchingWithOffSet:offsetY];
        }
        if (offsetY<-100) {
            _interestLabel.hidden = NO;
        }else{
            _interestLabel.hidden = YES;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    MDCell *cell = [[MDCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    if (cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
//    for (id subView in cell.contentView.subviews) {
//        [subView removeFromSuperview];
//    }
    DetailMusicListModel *model = _dataArray[indexPath.row];
    NSLog(@"");
    cell.name_Label.text = [NSString stringWithFormat:@"%@",model.mname];
    cell.singer_Label.text = [NSString stringWithFormat:@"%@",model.msinger];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-60-64)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        _tableView = tableView;
    }
    return _tableView;
}
- (void)musicDetaildownloadDatas{
    
    [[GD_DownloadCenter manager] postRequestWithURL:GET_musiclist parameters:@{@"uid":@"1",@"pver":@"1",@"maid":_needModel.maid} callBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"dic = %@",dic);
        NSArray *array = dic[@"ml"];
        if (array.count > 0) {
            for (NSDictionary *dic2 in array) {
                DetailMusicListModel *model = [[DetailMusicListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic2];
                model.mstate = @"100";
                [_dataArray addObject:model];
            }
        }
//        [_tableView reloadData];
    } callError:^(id Error) {
        GDLog(@"error");
    }];
    
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
