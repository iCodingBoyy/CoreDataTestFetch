//
//  CoreDataManager.m
//  CoreDataTest
//
//  Created by 马远征 on 13-12-19.
//  Copyright (c) 2013年 马远征. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager()
{
    NSDateFormatter *_formatter;
}
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation CoreDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static CoreDataManager *manager = nil;
    dispatch_once(&pred, ^{ manager = [[self alloc] init]; });
    return manager;
}

- (NSDateFormatter*)dateFormatter
{
    if (_formatter == nil)
    {
        _formatter = [[NSDateFormatter alloc] init];
    }
    return _formatter;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SMDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SMDataModel.sqlite"];
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    NSLog(@"------——perSisent--%@",_persistentStoreCoordinator.persistentStores);
    
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark - 数据处理

- (BOOL)insertNewRecord:(NSMutableDictionary*)infoDic date:(NSDate*)date
{
    if (infoDic == nil || date == nil)
    {
        return NO;
    }
    [self.dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [self.dateFormatter stringFromDate:date];
    
    [self.dateFormatter setDateFormat:@"MM"];
    NSString *month = [self.dateFormatter stringFromDate:date];
    
    [self.dateFormatter setDateFormat:@"dd"];
    NSString *day = [self.dateFormatter stringFromDate:date];
    
    [self.dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *time = [self.dateFormatter stringFromDate:date];
    
    FaceInfoEntity *infoEntity = (FaceInfoEntity*)[NSEntityDescription insertNewObjectForEntityForName:@"FaceInfoEntity" inManagedObjectContext:[self managedObjectContext]];
    infoEntity.year = year;
    infoEntity.month = month;
    infoEntity.day = day;
    infoEntity.time = time;
    infoEntity.score = infoDic[@"score"];
    infoEntity.faceMoisture = infoDic[@"faceMoisture"];
    infoEntity.faceOil = infoDic[@"faceOil"];
    
    NSError *error = nil;
    if (! [[self managedObjectContext]save:&error] || error)
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
        return NO;
    }
    return YES;
}

@end
