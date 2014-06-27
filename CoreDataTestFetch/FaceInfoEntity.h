//
//  FaceInfoEntity.h
//  CoreDataTestFetch
//
//  Created by 马远征 on 14-6-26.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FaceInfoEntity : NSManagedObject

@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * month;
@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSNumber * faceMoisture;
@property (nonatomic, retain) NSNumber * faceOil;
@property (nonatomic, retain) NSNumber * score;

@end
