//
//  Layer_Selected.m
//  BallDrop
//
//  Created by Rechee Jozil on 6/1/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "RJLayer.h"


@implementation RJLayer


- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.userInteractionEnabled = true;
        
        self.contentSize = CGSizeMake(320, 568);
        
        return self;
    }
    
    return self;
}

@end
