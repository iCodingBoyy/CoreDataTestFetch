//
//  ViewController.m
//  CoreDataTestFetch
//
//  Created by 马远征 on 14-6-26.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)insertBtnClick:(UIButton *)sender {
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *tomorrow, *yesterday;
    tomorrow = [[NSDate date] dateByAddingTimeInterval: secondsPerDay];
    yesterday = [[NSDate date] dateByAddingTimeInterval: -secondsPerDay];
    NSDictionary *dic = @{@"score": @80,@"faceMoisture":@37.5,@"faceOil":@16.8};
    CoreDataManager *mgr = [CoreDataManager sharedInstance];
    if ([mgr insertNewRecord:(NSMutableDictionary*)dic date:yesterday])
    {
        NSLog(@"---插入成功---");
    };
}

- (IBAction)FetchBtnClick:(UIButton *)sender {
    
    CoreDataManager *mgr = [CoreDataManager sharedInstance];
    NSManagedObjectContext *context = [mgr managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FaceInfoEntity" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *yearSortDes = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:NO];
    NSSortDescriptor *monthSortDes = [[NSSortDescriptor alloc] initWithKey:@"month" ascending:NO];
    NSSortDescriptor *daySortDes = [[NSSortDescriptor alloc] initWithKey:@"day" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:yearSortDes,monthSortDes,daySortDes, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setResultType:NSDictionaryResultType];
//    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"year",@"month",@"faceOil",@"faceMoisture",nil]];
//    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObjects:@"year",@"month",@"day",@"time",nil]];
    NSError *error = nil;
    NSArray *tempArray = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"-----tmpArray---%@",tempArray);
    NSNumber *sumM = [tempArray valueForKeyPath:@"@sum.faceMoisture"];
    NSNumber *sumO = [tempArray valueForKeyPath:@"@sum.faceOil"];
    NSLog(@"-----sum---%@:%@",sumM,sumO);
}
@end
