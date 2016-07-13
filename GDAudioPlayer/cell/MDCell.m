//
//  MDCell.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/12.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "MDCell.h"

@implementation MDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    _name_Label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 29)];
    _name_Label.textColor = [UIColor whiteColor];
    _name_Label.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_name_Label];
    
    _singer_Label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200,15)];
    _singer_Label.textColor = [UIColor whiteColor];
    _singer_Label.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_singer_Label];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
