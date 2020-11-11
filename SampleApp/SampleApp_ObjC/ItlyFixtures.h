//
//  ItlyFixtures.h
//  SampleApp_ObjC
//
//  Copyright © 2020 Iteratively. All rights reserved.
//
#pragma once

#import <ItlySdk/ItlySdk.h>
#import <ItlySchemaValidatorPlugin/ItlySchemaValidatorPlugin.h>

@interface ITLItly (Shared)
+(instancetype _Nonnull)shared;
@end

@interface ConsoleLogger : NSObject <ITLLogger>

@end

@interface ITLSchemaValidatorPlugin (Fixtures)
+(NSDictionary<NSString *,NSData *> * _Nonnull)defaultSchema;
@end

extern NSString* _Nonnull ContextOptionalEnumValue1;
extern NSString* _Nonnull ContextOptionalEnumValue2;

@interface Context : ITLEvent
+(instancetype _Nonnull)VALID_ONLY_REQUIRED_PROPS;
+(instancetype _Nonnull)VALID_ALL_PROPS;
+(instancetype _Nonnull)INVALID_NO_PROPS;

-(instancetype _Nonnull)initWithRequiredString:(NSString* _Nonnull)requiredString optionalEnum:(NSString* _Nullable)optionalEnum;
@end

@interface Identify : ITLEvent
+(instancetype _Nonnull)VALID_ALL_PROPS;

-(instancetype _Nonnull)initWithRequiredNumber:(NSValue* _Nonnull)requiredNumber optionalArray:(NSArray<NSString*>* _Nullable)optionalArray;
@end

@interface Group : ITLEvent
+(instancetype _Nonnull)VALID_ALL_PROPS;

-(instancetype _Nonnull)initWithRequiredBoolean:(NSValue* _Nonnull)requiredBoolean optionalString:(NSString* _Nullable)optionalString;
@end

@interface EventNoProperties : ITLEvent
+(instancetype _Nonnull )new;
@end
