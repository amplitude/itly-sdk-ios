//
//  ITLProperties.h
//  Sdk
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>

NS_SWIFT_NAME(Properties)
@interface ITLProperties : NSObject

@property (readonly, copy, nonnull) NSDictionary<NSString*, id>* properties;

-(instancetype _Nonnull )init:(NSDictionary<NSString*, id>* _Nonnull)dict;

@end
