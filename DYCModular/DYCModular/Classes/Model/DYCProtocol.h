//
//  Protocol.h
//  DYCModular
//
//  Created by 戴易超 on 2019/10/31.
//

#import <Foundation/Foundation.h>
#import "DYCParam.h"
NS_ASSUME_NONNULL_BEGIN

@interface DYCProtocol : NSObject
@property (nonatomic, strong) NSString *module;
@property (nonatomic, strong) NSString *function;
@property (nonatomic, strong) NSString *selector;
@property (nonatomic, strong) NSArray<DYCParam *> *params;

@end

NS_ASSUME_NONNULL_END
