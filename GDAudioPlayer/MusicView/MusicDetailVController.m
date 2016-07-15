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
#import "GetMusicUrlManager.h"
@interface MusicDetailVController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_getmusicUrlArray;
    BOOL isInsertPLSQL;
}
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GDTensionView *tensionView;

@property (nonatomic, strong) UILabel *interestLabel;
@end

@implementation MusicDetailVController

- (void)viewDidLoad {
    [super viewDidLoad];
    isInsertPLSQL = NO;
    _getmusicUrlArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgimageView.image = XUIImage(@"side_bg1");
    [self.view addSubview:bgimageView];

    self.navigationItem.title = _needModel.maname;
    
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
//    [self.tableView registerClass:[MDCell class] forCellReuseIdentifier:@"cell"];

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
        if (offsetY<-80) {
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
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell";
    MDCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[MDCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:XUIImage(@"MD_MoreHandle") forState:UIControlStateNormal];
    moreBtn.frame = CGRectMake(SCREENWIDTH - 50, (60-40)/2, 50, 40);
    [moreBtn addTarget:self action:@selector(cellMoreButtonSelectedRowAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.tag = indexPath.row;
    [cell addSubview:moreBtn];
    
    DetailMusicListModel *model = _dataArray[indexPath.row];
    cell.name_Label.text = [NSString stringWithFormat:@"%@",model.mname];
    cell.singer_Label.text = [NSString stringWithFormat:@"%@",model.msinger];
    return cell;
}
#pragma mark - 更多按钮
- (void)cellMoreButtonSelectedRowAtIndexPath:(UIButton *)sender{
    
    DetailMusicListModel *model = _dataArray[sender.tag];

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"下载(%@)",model.mname] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action2];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    DetailMusicListModel *model = _dataArray[indexPath.row];
    if (!isInsertPLSQL) {
        [self insert_SQLPL];
        isInsertPLSQL=YES;
    }
    UD_SetValue([NSNumber numberWithInteger:HandStart], Hand_pause);
    [[GetMusicUrlManager shareInstance] getlistenMusicURL:[NSString stringWithFormat:@"%@",model.mid] Singer:model.msinger Album:_needModel.maname];
}
- (void)insert_SQLPL{
    [[PlayListSQL shareInstance] createPlaylistSQL];
    [[PlayListSQL shareInstance] delete_playlistdata];
    if (_dataArray.count>0) {
        __weak typeof(self) weakSelf = self;
        [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //插库
            DetailMusicListModel *model = weakSelf.dataArray[idx];
            [[PlayListSQL shareInstance] insert_playlistWithMid:model.mid Mname:model.mname MSinger:model.msinger MState:model.mstate Mlrc:@"no" MIcon:@"no" MFile:@"no" Malbum:_needModel.maname];
        }];
    }
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
#pragma mark - 下载音乐列表的数据
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
        [_tableView reloadData];
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
