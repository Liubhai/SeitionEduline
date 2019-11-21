//
//  BRWeakMutableArray.m
//  YunKeTang
//
//  Created by git burning on 2019/6/16.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BRWeakMutableArray.h"


@interface BRWeakMutableArray()
@property (nonatomic, strong) NSPointerArray  *pointerArray;
@end
@implementation BRWeakMutableArray
- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.pointerArray = [NSPointerArray weakObjectsPointerArray];
}

- (void)addObject:(id)object {
    [self.pointerArray addPointer:(__bridge void *)(object)];
}

- (id)objectAtWeakMutableArrayIndex:(NSUInteger)index {
    return [self.pointerArray pointerAtIndex:index];
}
- (NSArray *)allObjects {
    return self.pointerArray.allObjects;
}
- (NSInteger)usableCount {
    return self.pointerArray.allObjects.count;
}
- (NSInteger)allCount {
    return self.pointerArray.count;
}
@end
