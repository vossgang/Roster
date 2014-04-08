//
//  Person.h
//  Roster
//
//  Created by Matthew Voss on 4/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) UIImage *personPicture;

@end
