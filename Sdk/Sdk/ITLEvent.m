//
//  ITLEvent.m
//  Sdk
//
//  Created by Konstantin Dorogan on 12.10.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ItlySdk/ItlySdk-Swift.h>
#import "ITLEvent.h"
#import "ITLEventMetadata.h"

@implementation ITLEvent

@synthesize name;
@synthesize properties;
@synthesize metadata;
@synthesize eventId;
@synthesize version;

-(instancetype _Nonnull )initWithName:(NSString * _Nonnull)nameParam
                        properties:(NSDictionary<NSString*, id>* _Nullable)propertiesParam
                        id:(NSString * _Nullable)idParam
                        version:(NSString * _Nullable)versionParam
                        metadata:(ITLEventMetadata* _Nullable)metadataParam;
{
    self = [super init];
    name = nameParam;
    properties = propertiesParam;
    eventId = idParam;
    version = versionParam;
    metadata = metadataParam;
    
    return self;
}

@end
