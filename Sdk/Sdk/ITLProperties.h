//
//  ITLProperties.h
//  Sdk
//
//  Created by Konstantin Dorogan on 19.10.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>

NS_SWIFT_NAME(Properties)
@interface ITLProperties : NSObject

@property (readonly, copy, nonnull) NSDictionary<NSString*, id>* properties;

-(instancetype _Nonnull )init:(NSDictionary<NSString*, id>* _Nonnull)dict;

@end
