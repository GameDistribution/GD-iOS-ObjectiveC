//
//  GDbannerData.h
//  TestGDApi
//
//  Created by Emre Demir on 26/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#ifndef GDbannerData_h
#define GDbannerData_h

@interface GDbannerData : NSObject

@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) int timeOut;
@property (nonatomic) int color;
@property (nonatomic,strong) NSString* url;
@property (nonatomic,strong) NSString* textAdv;
@property (nonatomic) Boolean enable;
@property (nonatomic) Boolean pre;
@property (nonatomic) int showAfterTimeout;
@property (nonatomic) float apiVersion;
@property (nonatomic,strong) NSString* adUnit;
@property (nonatomic,strong) NSString* affiliateId;

@end


#endif /* GDbannerData_h */
