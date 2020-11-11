//
//  ITLPlugin.m
//  Sdk
//
//  Copyright © 2020 Iteratively. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ItlySdk/ItlySdk-Swift.h>
#import <ItlySdk/ITLPlugin.h>

@implementation ITLPlugin

@synthesize pluginId;

- (instancetype)initWithId:(NSString *)id {
    self = [super init];
    pluginId = id;
    return self;
}

-(void)alias:(NSString * _Nonnull)userId previousId:(NSString * _Nullable)previousId {

}

- (void)flush {

}

- (void)group:(NSString * _Nullable)userId groupId:(NSString * _Nonnull)groupId properties:(ITLProperties* _Nullable)properties {

}

- (void)identify:(NSString * _Nullable)userId properties:(ITLProperties* _Nullable)properties {

}

- (void)load:(ITLItlyOptions * _Nonnull)options {

}

- (void)postAlias:(NSString * _Nonnull)userId previousId:(NSString * _Nullable)previousId {

}

- (void)postGroup:(NSString * _Nullable)userId groupId:(NSString * _Nonnull)groupId properties:(ITLProperties* _Nullable)properties validationResults:(NSArray<ITLValidationResponse *> * _Nonnull)validationResults {

}

- (void)postIdentify:(NSString * _Nullable)userId properties:(ITLProperties* _Nullable)properties validationResults:(NSArray<ITLValidationResponse *> * _Nonnull)validationResults {

}

- (void)postTrack:(NSString * _Nullable)userId event:(ITLEvent * _Nonnull)event validationResults:(NSArray<ITLValidationResponse *> * _Nonnull)validationResults {

}

- (void)reset {

}

- (void)shutdown {

}

- (void)track:(NSString * _Nullable)userId event:(ITLEvent * _Nonnull)event {

}

- (ITLValidationResponse * _Nonnull)validate:(ITLEvent * _Nonnull)event {
    return [[ITLValidationResponse alloc] initWithValid: TRUE
                                                message: nil
                                               pluginId: nil];
}


@end
