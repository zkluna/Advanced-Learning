//
//  User.m
//  PhotoData
//
//  Created by zhaoke on 2017/7/20.
//  Copyright © 2017年 hhh. All rights reserved.
//

#import "User.h"

static NSString * const IdentifierKey = @"identifier";
static NSString * const UserNameKey = @"username";
static NSString * const FirstNameKey = @"firstname";
static NSString * const LastNameKey = @"lastname";
static NSString * const PhotosKey = @"phots";

@implementation User

- (NSString *)description {
    NSString *formatString = @"<%@: %p> (%lld) \"%@\"";
    return [NSString stringWithFormat:formatString,[self class], self, (long long)self.identifier, self.userName];
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt64:self.identifier forKey:IdentifierKey];
    [coder encodeObject:self.userName forKey:UserNameKey];
    [coder encodeObject:self.firstName forKey:FirstNameKey];
    [coder encodeObject:self.lastName forKey:LastNameKey];
    [coder encodeObject:self.photos forKey:PhotosKey];
}
- (BOOL)requiresSecureCoding {
    return YES;
}
- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if(self){
        self.identifier = [coder decodeInt64ForKey:IdentifierKey];
        self.userName = [coder decodeObjectOfClass:[NSString class] forKey:UserNameKey];
        self.firstName = [coder decodeObjectOfClass:[NSString class] forKey:FirstNameKey];
        self.lastName = [coder decodeObjectOfClass:[NSString class] forKey:LastNameKey];
        self.photos = [coder decodeObjectOfClass:[NSArray class] forKey:PhotosKey];
    }
    return self;
}
- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
}
- (NSUInteger)numberOfPhotosTaken {
    return self.photos.count;
}

@end
