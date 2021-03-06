//
//  Food.h
//  Lhk-food
//
//  Created by leadmap on 14/10/24.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject

@property (nonatomic,strong) NSString *food_name;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSNumber *rate; //食物的评分
@property (nonatomic,strong) NSNumber *price;   //价格
@property (nonatomic,strong) NSNumber *onSalePrice; //原价

-(id) initWithDictionary:(NSDictionary *)dic;

@end
