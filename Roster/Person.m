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
        self.personPicture = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"picture"]];
        self.personType = [aDecoder decodeIntegerForKey:@"peopleType"];
    }
    
    
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:UIImagePNGRepresentation(self.personPicture) forKey:@"picture"];
    [aCoder encodeInteger:self.personType forKey:@"peopleType"];
    
}



@end