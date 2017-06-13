//
//  HomePageCollectionView.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/12.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "HomePageCollectionView.h"
static NSString *const cellIDentifier = @"celll";
@interface HomePageCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *musicdataArray;
@end

@implementation HomePageCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _musicdataArray = [NSMutableArray array];
        [self drawContext];
        [self refresh];
    }
    return self;
}
- (void)refresh{
    __weak typeof(self) weakSelf = self;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestToServerDownloadDatas];
    }];
}
- (void)drawContext {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.bounds.size.height) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIDentifier];
    [self addSubview:self.collectionView];
    
    [self requestToServerDownloadDatas];
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _musicdataArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellIdentifier = cellIDentifier;
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    for (id subView in cell.subviews) {
        [subView removeFromSuperview];
    }
    if (_musicdataArray.count>0) {
        MusicModel *model = _musicdataArray[indexPath.row];
        UIImageView *singleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREENWIDTH-80)/3, (SCREENWIDTH-80)/3)];
        singleImage.userInteractionEnabled = YES;
        [singleImage sd_setImageWithURL:[NSURL URLWithString:model.mashow_s] placeholderImage:XUIImage(@"专辑封面")];
        [cell addSubview:singleImage];
        
        UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (SCREENWIDTH-80)/3+2, (SCREENWIDTH-80)/3, 38)];
        namelabel.font = [UIFont systemFontOfSize:14];
        namelabel.textColor = [UIColor whiteColor];
        namelabel.numberOfLines = 0;
        namelabel.textAlignment = NSTextAlignmentCenter;
        NSString *text = [NSString stringWithFormat:@"%@",model.maname];
        NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGRect rect = [text boundingRectWithSize:CGSizeMake((SCREENWIDTH-40)/3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        if(rect.size.height < 20){
            namelabel.text = [NSString stringWithFormat:@"%@\n",model.maname];
        }
        else {
            namelabel.text = [NSString stringWithFormat:@"%@",model.maname];
        }
        [cell addSubview:namelabel];
        
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREENWIDTH-80)/3, (SCREENWIDTH-80)/3+40);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 5, 20);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_gd_delegate respondsToSelector:@selector(collectiondidSelectItemAtIndexPathModel:)]) {
        MusicModel *model = _musicdataArray[indexPath.row];
        [_gd_delegate collectiondidSelectItemAtIndexPathModel:model];
    }
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    //临时改变个颜色，看好，只是临时改变的。如果要永久改变，可以先改数据源，然后在cellForItemAtIndexPath中控制。（和UITableView差不多吧！O(∩_∩)O~）
//    cell.backgroundColor = [UIColor greenColor];
//    NSLog(@"item======%ld",indexPath.item);
//    NSLog(@"row=======%ld",indexPath.row);
//    NSLog(@"section===%ld",indexPath.section);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)requestToServerDownloadDatas{
    
    
#if 0
    NSString *str = @"http://page.amap.com/ws/page/upload/?ent=2&in=wDJRQXjFuTZWCVWigioX4ftIA6cZRmqNSVKTsrYWzn9MonJITvfTuBvL9%2B4DwH46TENJlBkcvn58KFcoOvtMOwJ%2FzS27fD8VkajARp%2Fah%2BcwdFFIbq1fgt3ceHMLQi0cpVcedGg%2FyZJ%2BzGciHOAXuxe3t8uxkfDxp3JzVcKrZsb%2FBJy9tLrt8ePjw%2F%2B0NUvzF8sMRWjxrxc3%2BVYtZKi%2FD7NKfV8sQmfNO5A1dZpsRUXM7Cq4%2FuaSbpdyIs8SsFh8d%2BSZSIBYWBpTru2a20uOnefM8mjwqWNcGZfCDgRGH0Jb%2BDj30eDYYSryaaawS77bPZhb6avbCdgyT6tYFIbKudzLO%2FQpQoxsBPA65vnvnTPrg%2FdxGQwWIs%2BsmuR3Ld4yBPUlEQGNpQDeHEaw72XYEkll9cTdWzuimFfmiawZ%2Fx2uCv%2Bu54Gc%2FnId23OaZ6vt1zqonTqPKkkV1kF7qhr3%2F2fvH4c5HmAPv0im1XpNu6xZEDUq1aT1crMrJZSdayEercnvL1Obi70h%2FKbwEELzs3rF%2BPAzIurUokTqctYB%2FW8ATzH9yMQkPDMStKEUwHRaQukKJyCZi1apNbx6S9jMayvhSEamoYh2vNNZzHX4OLCWaeMCq7AJ7zlXpky0p33d%2Fd7p8RRPxkT2%2FiyuC27tZzO6zhmr7Ca%2B2pnuClJRba4%2FuACISKhKl0mZs%2FkxbT8X1M6d7cVw3NxADaXH70%2F48p%2Fv4mIKQJQIemfD5pk0Z6m4ugGhdUWXtTQfW88ibVTpsBuQ%2BqLmGWlVDf19aO1ACbxu2MUOrg9hKzEAZGeSjD15k1PaoRSJqp93V9llazrcLE%2FkLQ8httPl2EPf5JtNJZ%2B2hH92TfvdrJMV3uHtRWcJ7z42KdFFvQ%3D%3D";
    /*
     2016-10-27 10:52:36.152 GDAudioPlayer[1093:236731] -{
     code = 5;
     message = "file empty";
     result = 0;
     timestamp = 1477536756056;
     version = "1.0";
     }
     */
    
    NSString *str1 = @"http://page.amap.com/ws/page/upload/?ent=2&in=Izt%2Fv1KtiVOH0%2BF0raU4nm%2B1%2BxXzJxZVn8qdkvXKqUTdMLZLpwrHWRbU1v8LR68Onp8v05SG0DqjGOCSi%2FgjCWQ2U4nUmQSQJtBBlM8pxQkO%2B%2BO2faDIO%2FhsMFGb06EvKHDERhekFNimMTHvoNh3MSBPEbhzGyuD7AnmpTPAoL9gv%2Bg5VnGj9fMtc8dfiBPNrjxegCDoITgV%2FpNhhoxnNDi4RmkRBNyrnZgTr8tly9WebEfCdcx46g1%2FRq52QGtUvJ0fhD%2BKrcbHPR9NWsfI0ZRaJAH7AMDuW13qsgCAsL%2BnXlmTsG4hANkMMU8e%2FyBlEPsuMkhHpTXaO3Ij%2BECoYEtt4fA29tvb35%2BdM2hUuaUiudYvlsRi2AkZcdFS36FLW6pziHGPCDwYaEMx7TH%2FIQtszeF0SVG9k5ePlFb2u8PkASMF8%2FDCc4C1OeA5EAUCjS6rkPII726oMv6XsW9FwyktJq1ZGHRhUVYRddLqLar46zp78QnYhK9zBqOP92kF4xTBcQ6wJkpqwMBd2SFjO5jbIRuL%2Fl7Vxb6bgOabG8hso7kZNs%2Biz1RmfWjB5xshLnXrjQbcpNGSHVm8sG21QRvlZuIBv9AwzuuvAOGc2LuWCoG1eBL5xiubsySzsdz37r8uuAhFkzFlXvaQuBeVh998DrOXdTP20M3x2BCBi0bcI6u%2FHjZD8rbFmAYInZfYB%2FzzgAdWPrcFsbLNaZkMb2GbytUjsmm019xzZpFAWK69Rl3U3MTKNU9y0x1TsbEl6BmAcdoLXxpYaRijC%2BannGYXtbEWLlif8DSnTG4eMhf2zl91SpA2XF6cLH4Ary7a6fK%2Fr85wlpd46Icb";
    
    [[GD_DownloadCenter manager] postRequestWithURL:str1 parameters:@{} callBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"-%@",dic);
//        NSArray *array = dic[@"mal"];
//        [_musicdataArray removeAllObjects];
//        //        NSLog(@"%@",array);
//        for (NSDictionary *dic2 in array) {
//            MusicModel *model = [[MusicModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic2];
//            [_musicdataArray addObject:model];
//        }
//        [self.collectionView reloadData];
//        [_collectionView.mj_header endRefreshing];
    } callError:^(id Error) {
        GDLog(@"请求错误");
    }];
#endif
    
#if 1
    [[GD_DownloadCenter manager] postRequestWithURL:GET_ma_list parameters:@{@"uid":@"1",@"pver":@"3"} callBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"mal"];
        [_musicdataArray removeAllObjects];
//        NSLog(@"%@",array);
        for (NSDictionary *dic2 in array) {
            MusicModel *model = [[MusicModel alloc] init];
            [model setValuesForKeysWithDictionary:dic2];
            [_musicdataArray addObject:model];
        }
        [self.collectionView reloadData];
        [_collectionView.mj_header endRefreshing];
    } callError:^(id Error) {
        GDLog(@"请求错误");
    }];
#endif
}

@end
