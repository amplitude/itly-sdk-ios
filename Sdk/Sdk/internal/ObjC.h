//
//  ObjC.h
//  ItlyCore
//
//  Created by Konstantin Dorogan on 06.10.2020.
//  Copyright © 2020 Konstantin Dorogan. All rights reserved.
//

#ifndef ObjC_h
#define ObjC_h

#import <Foundation/Foundation.h>

@interface ObjC : NSObject

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end

#endif /* ObjC_h */
