//
//  ITLPlugin.h
//  Sdk
//
//  Copyright © 2020 Iteratively. All rights reserved.
//
#import <Foundation/Foundation.h>

@class ITLProperties;
@class ITLItlyOptions;
@class ITLValidationResponse;
@class ITLEvent;

NS_SWIFT_NAME(Plugin)
@interface ITLPlugin : NSObject
@property (readonly, copy, nonnull) NSString* pluginId NS_SWIFT_NAME(id);

-(instancetype _Nonnull )initWithId:(NSString * _Nonnull)id;

- (void)load:(ITLItlyOptions * _Nonnull)options;

-(void)alias:(NSString * _Nonnull)userId previousId:(NSString * _Nullable)previousId;
- (void)postAlias:(NSString * _Nonnull)userId previousId:(NSString * _Nullable)previousId;

- (void)group:(NSString * _Nullable)userId groupId:(NSString * _Nonnull)groupId properties:(ITLProperties* _Nullable)properties;
- (void)postGroup:(NSString * _Nullable)userId groupId:(NSString * _Nonnull)groupId properties:(ITLProperties* _Nullable)properties validationResults:(NSArray<ITLValidationResponse *> * _Nonnull)validationResults;

- (void)identify:(NSString * _Nullable)userId properties:(ITLProperties* _Nullable)properties;
- (void)postIdentify:(NSString * _Nullable)userId properties:(ITLProperties* _Nullable)properties validationResults:(NSArray<ITLValidationResponse *> * _Nonnull)validationResults;

- (void)track:(NSString * _Nullable)userId event:(ITLEvent * _Nonnull)event;
- (void)postTrack:(NSString * _Nullable)userId event:(ITLEvent * _Nonnull)event validationResults:(NSArray<ITLValidationResponse *> * _Nonnull)validationResults;

- (ITLValidationResponse * _Nonnull)validate:(ITLEvent * _Nonnull)event;

- (void)flush;
- (void)reset;
- (void)shutdown;
@end
