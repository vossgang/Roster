//
//  Person.m
//  Roster
//
//  Created by Matthew Voss on 4/7/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "Person.h"

@implementation Person

-(NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.personType = [aDecoder decodeIntegerForKey:@"peopleType"];
        
        self.userRedColor = [aDecoder decodeFloatForKey:@"redcolor"];
        self.userGreenColor = [aDecoder decodeFloatForKey:@"greencolor"];
        self.userBlueColor = [aDecoder decodeFloatForKey:@"bluecolor"];
        
        self.userBGColor = [UIColor colorWithRed:self.userRedColor green:self.userGreenColor blue:self.userBlueColor alpha:1];
        
        self.twitterUserName = [aDecoder decodeObjectForKey:@"twitter"];
        self.githubUserName = [aDecoder decodeObjectForKey:@"github"];
        
        self.randomPicturePathExtension = [aDecoder decodeObjectForKey:@"randomPicturePathExtension"];
        self.picturePath = [aDecoder decodeObjectForKey:@"picturePath"];
        self.personPicture     = [UIImage imageWithContentsOfFile:self.picturePath];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeInteger:self.personType forKey:@"peopleType"];
    
    [aCoder encodeFloat:self.userBlueColor forKey:@"bluecolor"];
    [aCoder encodeFloat:self.userGreenColor forKey:@"greencolor"];
    [aCoder encodeFloat:self.userRedColor forKey:@"redcolor"];
    
    [aCoder encodeObject:self.twitterUserName forKey:@"twitter"];
    [aCoder encodeObject:self.githubUserName forKey:@"github"];
    
    [aCoder encodeObject:self.randomPicturePathExtension forKey:@"randomPicturePathExtension"];
    
    self.picturePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:_randomPicturePathExtension];
    
    NSData *imageData = UIImageJPEGRepresentation(self.personPicture, .5);
    [imageData writeToFile:self.picturePath atomically:YES];
    [aCoder encodeObject:self.picturePath forKey:@"picturePath"];
    
}

@end