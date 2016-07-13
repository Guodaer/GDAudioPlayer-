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
    }
    return self;
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
    [[GD_DownloadCenter manager] postRequestWithURL:GET_ma_list parameters:@{@"uid":@"1",@"pver":@"3"} callBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic[@"mal"];
//        NSLog(@"%@",array);
        for (NSDictionary *dic2 in array) {
            MusicModel *model = [[MusicModel alloc] init];
            [model setValuesForKeysWithDictionary:dic2];
            [_musicdataArray addObject:model];
        }
        [self.collectionView reloadData];
    } callError:^(id Error) {
        GDLog(@"请求错误");
    }];
}

@end
