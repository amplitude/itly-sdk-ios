//
//  ITLEvent.m
//  Sdk
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ItlySdk/ItlySdk-Swift.h>
#import <ItlySdk/ITLEvent.h>
#import <ItlySdk/ITLEventMetadata.h>

@implementation ITLEvent
@synthesize name;
@synthesize metadata;
@synthesize eventId;
@synthesize version;


-(instancetype _Nonnull )initWithName:(NSString * _Nonnull)nameParam
                        propertiesDict:(NSDictionary<NSString*, id>* _Nullable)propertiesDictParam
                        id:(NSString * _Nullable)idParam
                        version:(NSString * _Nullable)versionParam
                        metadata:(ITLEventMetadata* _Nullable)metadataParam
{
    self = [super init:propertiesDictParam];
    name = nameParam;
    eventId = idParam;
    version = versionParam;
    metadata = metadataParam;

    return self;
}

@end
