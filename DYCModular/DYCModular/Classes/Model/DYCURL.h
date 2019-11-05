//
//  DYCURL.h
//  DYCModular
//
//  Created by 戴易超 on 2019/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYCURL : NSURL


@property (nonatomic, strong, readonly) NSDictionary *module_param;

@property (nonatomic, strong, readonly) NSArray<NSString *> *module_names;

@property (nonatomic, copy, readonly) NSString *module_method;

@end

NS_ASSUME_NONNULL_END
