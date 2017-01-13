//
//  GDpostObj.h
//  gdapi
//
//  Created by Emre Demir on 19/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#ifndef GDpostObj_h
#define GDpostObj_h

@interface GDpostObject:NSObject

@property (nonatomic,strong) NSString* gid;
@property (nonatomic,strong) NSString* ref;
@property (nonatomic,strong) NSString* sid;
@property (nonatomic,strong) NSString* ver;
//@property (nonatomic,strong) NSString* cbp;
@property (nonatomic,strong) NSString* act;

-(NSString*) toQueryString;

@end

#endif /* GDpostObj_h */
