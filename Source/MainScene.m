//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "RJLayer.h"
#import "RJLiveCell.h"
#import "RJDeadCell.h"
#import "RJCellLayer.h"



@implementation MainScene
{
    
    CCTiledMapLayer *layer;
    
    CCTiledMap *tiledMap;
    
    RJCellLayer *cellLayer;
    
    //Test
}


- (void) updateGeneration: (CCTime) deltaTime
{
    [cellLayer generateNewGeneration];
}
- (void) didLoadFromCCB
{
    self.userInteractionEnabled = true;
    
    tiledMap = [CCTiledMap tiledMapWithFile:@"deadTiles.tmx"];
    
    tiledMap.contentSize = CGSizeMake(320, 568);
    
    [self addChild:tiledMap];
    
    layer = [tiledMap layerNamed:@"Tile Layer 1"];
    
    cellLayer = [RJCellLayer cellLayerFromTiledLayer:layer];
    
    [cellLayer randomizeLayer];
    
    [cellLayer generateNewGeneration];
    
    [self schedule:@selector(updateGeneration:) interval:1];
    
    [self addChild:cellLayer];
}

@end
