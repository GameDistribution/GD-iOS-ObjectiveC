//
//  GDpostObj.m
//  gdapi
//
//  Created by Emre Demir on 19/12/16.
//  Copyright © 2016 Emre Demir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDpostObj.h"

@implementation GDpostObject

-(NSString*) toQueryString{
    
    NSString* str=@"";
    
    if(self.gid != nil)
        str = [str stringByAppendingFormat:@"gid=%@&",[self.gid stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    if(self.ref != nil)
        str = [str stringByAppendingFormat:@"ref=%@&",[self.ref stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    if(self.sid != nil)
        str = [str stringByAppendingFormat:@"sid=%@&",[self.sid stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    if(self.ver != nil)
        str = [str stringByAppendingFormat:@"ver=%@&",[self.ver stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
//    if(self.cbp != nil)
//        str = [str stringByAppendingFormat:@"cbp=%@&",[self.cbp stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    if(self.act != nil)
        str = [str stringByAppendingFormat:@"act=%@&",[self.act stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
    
    str = [str substringWithRange:NSMakeRange(0,[str length] - 1)]; // remove last &
    
    return str;
}

@end
