//
//  ShopDetailTableViewCell.h
//  Lhk-food
//
//  Created by leadmap on 14/10/24.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *businessHours;
@property (weak, nonatomic) IBOutlet UIImageView *detailimg;
@property (weak, nonatomic) IBOutlet UILabel *avgMoney;

@property (weak, nonatomic) IBOutlet UIImageView *rateImage;

//-(void) Fill:
@end
