//
//  MyOffeTableViewController.m
//  Lhk-food
//
//  Created by leadmap on 14/12/9.
//  Copyright (c) 2014年 leadmap. All rights reserved.
//

#import "MyOffeTableViewController.h"
#import "MyOffeTableViewCell.h"

@interface MyOffeTableViewController ()

@property NSMutableArray *resultArray;  //搜索结果列表

@end

@implementation MyOffeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _resultArray = [[NSMutableArray alloc]init];
    
    //设置代理
//    _asiFormDataRequest.delegate = self;
    //不显示后退按钮的标题
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.image=[UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem=backItem;
    
    [self query];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_resultArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOffeTableViewCell *cell = (MyOffeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"offeIdentifier" forIndexPath:indexPath];
    

    Offers * offer = [_resultArray objectAtIndex:[indexPath row]];
    cell.foodname.text = offer.food.food_name;
//    cell.food
    return cell;
}


//查询
- (void) query {
    
    
    //    self.shopSearchSpec.currentpage  =1; //测试使用，最终要修改
    
    NSString *query;
    
    query =  ShopsOffers(_shopSearchSpec.shopid,1);
    
//    if(_showtype == ResultTableStyleSearch)
//    {
//        query = ShopList(self.shopSearchSpec.key,[self.shopSearchSpec.category intValue ],self.shopSearchSpec.lat,self.shopSearchSpec.lng,self.shopSearchSpec.scope,self.shopSearchSpec.currentPage);
//        
//    }
//    else
//    {
//        query = Recommends(0.0,0.0,0,0.0,1);
//    }
    
    NSString *strUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    //    [SVProgressHUD show];
    
    //    url= [NSURL URLWithString:[NSString stringWithFormat:@"http://114.215.158.76/foodmap/index.php/Home/shops?keyword=%@&category=%d&lat=%.3f&lng=%.3f&scope=%d",str,123,.0,.0,0] ];
    
    //    url=[NSURL URLWithString:@"http://114.215.158.76/foodmap/index.php/Home/shops?keyword=abc&category=&lat=&lng=&scope="];
    
    NSLog(@"%@",url);
    
    _asiFormDataRequest = [ASIHTTPRequest requestWithURL:url];
    [_asiFormDataRequest setDelegate:self];
    [_asiFormDataRequest startAsynchronous];
    
}


#pragma mark - Your actions


//- (void)requestFinished:(ASIHTTPRequest *)request;
//- (void)requestFailed:(ASIHTTPRequest *)request;

-(void) requestFailed:(ASIHTTPRequest *)request
{
    //    [SVProgressHUD dismiss];
    
    NSLog(@"请求出错");
}

-(void) requestFinished:(ASIHTTPRequest *)request
{
    //NSArray* result = nil;
    NSData *data =[request responseData];
    //     NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error;
    if (data!=nil) {
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error] ;
        
        //        NSArray* arrayResult =[dic objectForKey:@"results"];
        
        
        //        NSLog(@"%@",dic);
        
        NSArray *pageresultArray = [dic objectForKey:@"result"];
        
        //如果result直接为空值，则直接返回 判断dic中的值是否为空，得以下的方式
        if((NSNull *)pageresultArray == [NSNull null] ||pageresultArray == nil)
        {
            return;
        }
        //        NSInteger shopid = [[tmps objectForKey:@"id"] integerValue];
        
        self.shopSearchSpec.totalCount = [[dic objectForKey:@"totalCount"] integerValue];
        self.shopSearchSpec.resultCount =[[dic objectForKey:@"resultCount"] integerValue];
        self.shopSearchSpec.currentPage =[[dic objectForKey:@"currentPage"] integerValue];
        
        self.shopSearchSpec.numberPerPage = [[dic objectForKey:@"numberPerPage"] integerValue];
        
        for(int i =0 ;i < [pageresultArray count] ; i++)
        {
            
            NSDictionary *dic = [pageresultArray objectAtIndex:i] ;
            
            //添加优惠和店铺信息
            Offers *offer = [[Offers alloc] initWithDictionary:dic];
            offer.food = [[Food alloc] initWithDictionary:dic];
//            Shop *shop = [[Shop alloc] initWithDictionary:dic];
       
            [self.resultArray addObject:offer];//临时使用，应该使用一个类代替
            //            NSLog(@"%@",shop.address);
            
        }
        //        NSLog(@"店铺数量是 %d",[dic count]);
        //        _testLabel.text = str;
        [self.tableView  reloadData];
        
//        [self.tableView footerEndRefreshing];
        
        //        [SVProgressHUD dismiss];
        
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
