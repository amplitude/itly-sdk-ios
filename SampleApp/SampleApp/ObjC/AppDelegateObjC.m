//
//  AppDelegateObjC.m
//  SampleApp_Carthage
//
//  Created by Konstantin Dorogan on 08.10.2020.
//

#import "AppDelegateObjC.h"
#import <ItlySdk/ItlySdk.h>
#import <ItlySchemaValidatorPlugin/ItlySchemaValidatorPlugin.h>
#import <ItlyIterativelyPlugin/ItlyIterativelyPlugin.h>
#import "SampleApp_Carthage-Swift.h"
//#import "ItlyFixturesObjC.h"

@implementation AppDelegateObjC

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    
    
    ITLIterativelyOptions* iterativelyPluginOptions = [[ITLIterativelyOptions alloc] initWithUrl:@"http://localhost:8080/test"
                                                                                     environment:ITLEnvironmentDevelopment
                                                                                      omitValues:FALSE
                                                                                       batchSize:1
                                                                                  flushQueueSize:1
                                                                                 flushIntervalMs:10000
                                                                                      maxRetries:25
                                                                              delayInitialMillis:10000
                                                                              delayMaximumMillis:3600000];
    
    NSError* error;
    ITLIterativelyPlugin* iterativelyPlugin = [[ITLIterativelyPlugin alloc] initWithApiKey:@"api-key"
                                                                                    config:iterativelyPluginOptions
                                                                                     error:&error];

    ITLValidationOptions* validationOptions = [[ITLValidationOptions alloc] initWithDisabled:false
                                                                                trackInvalid:true
                                                                              errorOnInvalid:false];
    ITLSchemaValidatorPlugin* validationPlugin = [[ITLSchemaValidatorPlugin alloc] initAndReturnError:&error];
    
    ConsoleLogger* logger = [[ConsoleLogger alloc] init];
    ITLItlyOptions* itlyOptions = [[ITLItlyOptions alloc] initWithContext:nil
                                                              environment:ITLEnvironmentDevelopment
                                                                 disabled:false
                                                                  plugins:@[iterativelyPlugin,
                                                                            validationPlugin]
                                                               validation:validationOptions
                                                                   logger:logger];
    
    [ITLItly.shared load:itlyOptions];

    
    NSString* userId = @"userId";
    
    [ITLItly.shared identify:userId
                  properties: [[Identify alloc] initWithRequiredNumber:42.0 optionalArray:nil]];
    
    [ITLItly.shared group:userId
                  groupId:@"groupId"
               properties:[[Group alloc ] initWithRequiredBoolean:true optionalString:nil]];
    
    [ITLItly.shared track:userId
                    event:[EventNoProperties new]];
    
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
