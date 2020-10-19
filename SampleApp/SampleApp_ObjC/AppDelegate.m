//
//  AppDelegate.m
//  SampleApp_ObjC
//
//  Created by Konstantin Dorogan on 12.10.2020.
//

#import "AppDelegate.h"
#import "ItlyFixtures.h"
#import <ItlySdk/ItlySdk.h>
#import <ItlySchemaValidatorPlugin/ItlySchemaValidatorPlugin.h>
#import <ItlyIterativelyPlugin/ItlyIterativelyPlugin.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    ITLIterativelyOptions* iterativelyPluginOptions = [[ITLIterativelyOptions alloc] initWithEnvironment:ITLEnvironmentDevelopment
                                                                                      omitValues:FALSE
                                                                                       batchSize:1
                                                                                  flushQueueSize:1
                                                                                 flushIntervalMs:10000
                                                                                      maxRetries:25
                                                                              delayInitialMillis:10000
                                                                              delayMaximumMillis:3600000];
    
    // Create plugins
    NSError* error;
    ITLIterativelyPlugin* iterativelyPlugin = [[ITLIterativelyPlugin alloc] init:@"api-key"
                                                                             url:@"http://localhost:8080/test"
                                                                          config:iterativelyPluginOptions
                                                                           error:&error];

    ITLSchemaValidatorPlugin* validationPlugin = [[ITLSchemaValidatorPlugin alloc] initWithSchemasMap:ITLSchemaValidatorPlugin.defaultSchema
                                                                                                error:&error];

    
    ITLValidationOptions* validationOptions = [[ITLValidationOptions alloc] initWithDisabled:false
                                                                                trackInvalid:true
                                                                              errorOnInvalid:false];
    
    
    ITLItlyOptions* itlyOptions = [[ITLItlyOptions alloc] initWithEnvironment:ITLEnvironmentDevelopment
                                                                 disabled:false
                                                                  plugins:@[iterativelyPlugin,
                                                                            validationPlugin]
                                                               validation:validationOptions
                                                                   logger:[ConsoleLogger new]];
    
    [ITLItly.shared load:[[Context alloc] initWithRequiredString:@"Required string" optionalEnum:nil]
                 options:itlyOptions];

    
    
    NSString* userId = @"userId";
    
    [ITLItly.shared identify:userId
                  properties: [[Identify alloc] initWithRequiredNumber:@42.0 optionalArray:nil]];
    
    [ITLItly.shared group:@"groupId"
               properties:[[Group alloc] initWithRequiredBoolean:@YES optionalString:nil]];
    
    [ITLItly.shared track:[EventNoProperties new]];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


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
