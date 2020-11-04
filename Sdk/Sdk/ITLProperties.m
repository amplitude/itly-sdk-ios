//
//  ITLProperties.m
//  Sdk
//
//  Created by Konstantin Dorogan on 19.10.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ItlySdk/ITLProperties.h>

@implementation ITLProperties

@synthesize properties;

-(instancetype _Nonnull )init:(NSDictionary<NSString*, id>* _Nonnull)dict
{
    self = [super init];

    NSMutableDictionary* dictCopy = [dict mutableCopy];
    NSArray* keysForNullValues = [dictCopy allKeysForObject:[NSNull null]];
    [dictCopy removeObjectsForKeys:keysForNullValues];
    
    properties = dictCopy;
    
    return self;
}

@end
