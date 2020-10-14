//
//  ITLEvent.h
//  Sdk
//
//  Created by Konstantin Dorogan on 12.10.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "ITLEventMetadata.h"

@protocol ITLProperties;

NS_SWIFT_NAME(Event)
@interface ITLEvent : NSObject <ITLProperties>

@property (readonly, copy, nonnull) NSString* name;
@property (readonly, copy, nonnull) NSDictionary<NSString*, id>* properties;
@property (readonly, copy, nonnull) ITLEventMetadata* metadata;
@property (readonly, copy, nonnull) NSString* eventId NS_SWIFT_NAME(id);
@property (readonly, copy, nonnull) NSString* version;

-(instancetype _Nonnull )initWithName:(NSString * _Nonnull)nameParam
                        properties:(NSDictionary<NSString*, id>* _Nullable)propertiesParam
                        id:(NSString * _Nullable)idParam
                        version:(NSString * _Nullable)versionParam
                        metadata:(ITLEventMetadata* _Nullable)metadataParam;

@end
