//
//  PetralHttpManager.h
//  Petral_Example
//
//  Created by huangzhibin on 2019/8/6.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PetralHttpManager : NSObject

+(instancetype) sharedInstance;

- (void)startServer:(NSString*) rootDirectory;

@property (nonatomic, copy) NSString *rootDirectory;
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
