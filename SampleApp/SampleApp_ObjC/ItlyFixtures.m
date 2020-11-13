//
//  ItlyFixtures.m
//  SampleApp_ObjC
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItlyFixtures.h"

@implementation ITLItly (Shared)

+(instancetype _Nonnull)shared {
    static ITLItly* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ITLItly new];
    });

    return sharedInstance;
}

@end

@implementation ConsoleLogger
- (void)debug:(NSString * _Nonnull)message {
    NSLog(@"debug: %@", message);
}
- (void)info:(NSString * _Nonnull)message {
    NSLog(@"info: %@", message);
}
- (void)warn:(NSString * _Nonnull)message {
    NSLog(@"warn: %@", message);
}
- (void)error:(NSString * _Nonnull)message {
    NSLog(@"error: %@", message);
}

@end

@implementation ITLSchemaValidatorPlugin (Fixtures)
+(NSDictionary<NSString *,NSData *> *)defaultSchema {
    static NSDictionary<NSString *,NSData *>* schema = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const char* contextSchema = "{\"$id\":\"https://iterative.ly/company/77b37977-cb3a-42eb-bce3-09f5f7c3adb7/context\",\"$schema\":\"http://json-schema.org/draft-07/schema#\",\"title\":\"Context\",\"description\":\"\",\"type\":\"object\",\"properties\":{\"requiredString\":{\"description\":\"description for context requiredString\",\"type\":\"string\"},\"optionalEnum\":{\"description\":\"description for context optionalEnum\",\"enum\":[\"Value 1\",\"Value 2\"]}},\"additionalProperties\":false,\"required\":[\"requiredString\"]}";
        const char* groupSchema = "{\"$id\":\"https://iterative.ly/company/77b37977-cb3a-42eb-bce3-09f5f7c3adb7/group\",\"$schema\":\"http://json-schema.org/draft-07/schema#\",\"title\":\"Group\",\"description\":\"\",\"type\":\"object\",\"properties\":{\"requiredBoolean\":{\"description\":\"Description for group requiredBoolean\",\"type\":\"boolean\"},\"optionalString\":{\"description\":\"Description for group optionalString\",\"type\":\"string\"}},\"additionalProperties\":false,\"required\":[\"requiredBoolean\"]}";
        const char* identifySchema = "{\"$id\":\"https://iterative.ly/company/77b37977-cb3a-42eb-bce3-09f5f7c3adb7/identify\",\"$schema\":\"http://json-schema.org/draft-07/schema#\",\"title\":\"Identify\",\"description\":\"\",\"type\":\"object\",\"properties\":{\"optionalArray\":{\"description\":\"Description for identify optionalArray\",\"type\":\"array\",\"uniqueItems\":false,\"items\":{\"type\":\"string\"}},\"requiredNumber\":{\"description\":\"Description for identify requiredNumber\",\"type\":\"number\"}},\"additionalProperties\":false,\"required\":[\"requiredNumber\"]}";

        schema = @{
            @"context": [NSData dataWithBytes:contextSchema length:strlen(contextSchema)],
            @"group": [NSData dataWithBytes:groupSchema length:strlen(groupSchema)],
            @"identify": [NSData dataWithBytes:identifySchema length:strlen(identifySchema)]
        };
    });

    return schema;
}
@end


NSString* ContextOptionalEnumValue1 = @"Value 1";
NSString* ContextOptionalEnumValue2 = @"Value 2";

@implementation Context
+(instancetype)VALID_ONLY_REQUIRED_PROPS {
    return [[Context alloc] initWithRequiredString:@"Required context string" optionalEnum:nil];
}
+(instancetype)VALID_ALL_PROPS {
    return [[Context alloc] initWithRequiredString:@"Required context string" optionalEnum:ContextOptionalEnumValue1];
}
+(instancetype)INVALID_NO_PROPS {
    return [[Context alloc] initWithName:@"context" properties:nil id:nil version:nil];
}

-(instancetype)initWithRequiredString:(NSString* _Nonnull)requiredString optionalEnum:(NSString* _Nullable)optionalEnum {
    self = [super initWithName:@"context"
                    properties:[[ITLProperties alloc] init:@{@"requiredString": requiredString, @"optionalEnum": optionalEnum != nil ? optionalEnum : NSNull.null}]
                            id:nil
                       version:nil];
    return self;
}
@end

@implementation Identify : ITLEvent
+(instancetype)VALID_ALL_PROPS {
    return [[Identify alloc] initWithRequiredNumber:@2.0 optionalArray:@[@"optional"]];
}

-(instancetype)initWithRequiredNumber:(NSValue* _Nonnull)requiredNumber optionalArray:(NSArray<NSString*>* _Nullable)optionalArray {
    self = [super initWithName:@"identify"
                    properties:[[ITLProperties alloc] init:@{@"requiredNumber": requiredNumber, @"optionalArray": optionalArray != nil ? optionalArray : NSNull.null}]
                            id:nil
                       version:nil];
    return self;
}
@end

@implementation Group : ITLEvent
+(instancetype)VALID_ALL_PROPS {
    return [[Group alloc] initWithRequiredBoolean:@NO optionalString:@"I'm optional!"];
}

-(instancetype)initWithRequiredBoolean:(NSValue* _Nonnull)requiredBoolean optionalString:(NSString* _Nullable)optionalString {
    self = [super initWithName:@"group"
                    properties:[[ITLProperties alloc] init:@{@"requiredBoolean": requiredBoolean, @"optionalString": optionalString != nil ? optionalString : NSNull.null}]
                            id:nil
                       version:nil];
    return self;
}
@end

@implementation EventNoProperties : ITLEvent
+(instancetype)new {
    return [[EventNoProperties alloc] initWithName:@"Event No Properties" properties:nil id:nil version:nil];
}

@end
