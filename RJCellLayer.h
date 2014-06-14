//
//  RJCellLayer.h
//  BallDrop
//
//  Created by Rechee Jozil on 6/12/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RJLayer.h"
#import "RJDeadCell.h"
#import "RJLiveCell.h"
#import <stdlib.h>
#import "Cell.h"

@interface RJCellLayer : RJLayer

@property (nonatomic) CGSize mapSize;

- (void) randomizeLayer;

- (id) initWithMapSize: (CGSize) mapSize;

- (Cell *) cellatCoordinate: (CGPoint) coordinate;

- (Cell *) cellRightOfCell: (Cell *) cell;

- (Cell *) cellLeftOfCell: (Cell *) cell;

- (Cell *) cellAboveCell: (Cell *) cell;

- (Cell *) cellBelowCell: (Cell *) cell;

+ (RJLiveCell *) liveCell;

+ (RJDeadCell *) deadCell;

+ (RJCellLayer *) cellLayerFromTiledLayer: (CCTiledMapLayer *) tiledMapLayer;

typedef NS_ENUM(NSInteger, CellEdgeStyle)
{
    CellEdgeStyleLeft,
    CellEdgeStyleRight,
    CellEdgeStyleTop,
    CellEdgeStyleBotttom,
    CellEdgeStyleBottomLeft,
    CellEdgeStyleTopLeft,
    CellEdgeStyleBottomRight,
    CellEdgeStyleTopRight,
    CellEdgeStyleNone
};

- (CellEdgeStyle) edgeForCell: (Cell *) cell;

- (NSInteger) liveCountForCell: (Cell *) cell;

+ (BOOL) cellIsAlive: (Cell *) cell;

- (void) generateNewGeneration;
@end
