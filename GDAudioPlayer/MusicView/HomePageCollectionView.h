//
//  HomePageCollectionView.h
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/12.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

@protocol HomePageCollectionViewDelegate <NSObject>

- (void)collectiondidSelectItemAtIndexPathModel:(MusicModel*)model;

@end

@interface HomePageCollectionView : UIView

@property (nonatomic, assign) id<HomePageCollectionViewDelegate>gd_delegate;

@end
