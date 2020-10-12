//
//  main.m
//  SampleApp_Carthage
//
//  Created by Konstantin Dorogan on 08.10.2020.
//

#import <UIKit/UIKit.h>
#import "AppDelegateObjC.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegateObjC class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
