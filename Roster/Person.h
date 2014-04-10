//
//  Person.h
//  Roster
//
//  Created by Matthew Voss on 4/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>

enum personType {
    teacher,
    student
};

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;

@property (nonatomic, strong) NSString *twitterUserName;
@property (nonatomic, strong) NSString *githubUserName;

@property (nonatomic, strong) UIImage *personPicture;

@property (nonatomic, strong) NSString *randomPicturePathExtension;
@property (nonatomic, strong) NSString *picturePath;

@property (nonatomic) NSInteger personType;

@property (nonatomic) float userRedColor;
@property (nonatomic) float userBlueColor;
@property (nonatomic) float userGreenColor;

@property (nonatomic, strong) UIColor *userBGColor;

@end
