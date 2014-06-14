//
//  RJCellLayer.m
//  BallDrop
//
//  Created by Rechee Jozil on 6/12/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "RJCellLayer.h"




@implementation RJCellLayer
{
    
}


- (id) initWithMapSize: (CGSize) mapSize
{
    self = [super init];
    
    if(self)
    {
        _mapSize = mapSize;
        return self;
    }
    
    return self;
}

- (void) randomizeLayer
{
    NSMutableArray *childrenToRemove = [[NSMutableArray alloc] init];
    
    NSMutableArray *childrenToAdd = [[NSMutableArray alloc] init];
    
    for(Cell *deadCell in _children)
    {
        int randomNum = arc4random() % 5;
        
        if(randomNum == 0)
        {
            RJLiveCell *newLiveCell = [[RJLiveCell alloc] init];
            
            newLiveCell.position = deadCell.position;
            newLiveCell.tilePoint = deadCell.tilePoint;
            
            [childrenToAdd addObject:newLiveCell];
            [childrenToRemove addObject:deadCell];
        }
    }
    
    for(Cell *deadCell in childrenToRemove)
    {
        [self removeChild:deadCell];
    }
    
    childrenToRemove = nil;
    
    for(Cell *liveCell in childrenToAdd)
    {
        [self addChild:liveCell];
    }
    
    childrenToAdd = nil;
}

- (NSArray *) adjacentCellsForCell: (Cell *) cell
{
    NSMutableArray *adjecentCells = [[NSMutableArray alloc] initWithCapacity:8];
    
    CGPoint cellPoint = cell.tilePoint;
    
    Cell *diagnolTopLeft = [self cellatCoordinate:CGPointMake(cellPoint.x + 1, cellPoint.y - 1)];
    
    if(diagnolTopLeft != nil)
        [adjecentCells addObject:diagnolTopLeft];
    
    Cell *diagnolTopRight = [self cellatCoordinate:CGPointMake(cellPoint.x + 1, cellPoint.y + 1)];
    
    if(diagnolTopRight != nil)
        [adjecentCells addObject:diagnolTopRight];
    
    Cell *diagnolBottomLeft = [self cellatCoordinate:CGPointMake(cellPoint.x - 1, cellPoint.y - 1)];
    
    if(diagnolBottomLeft != nil)
        [adjecentCells addObject:diagnolBottomLeft];
    
    Cell *diagnolBottomRight = [self cellatCoordinate:CGPointMake(cellPoint.x - 1, cellPoint.y + 1)];
    
    if(diagnolBottomRight != nil)
        [adjecentCells addObject:diagnolBottomRight];
    
    Cell *aboveCell = [self cellAboveCell: cell];
    
    if(aboveCell != nil)
        [adjecentCells addObject:aboveCell];
    
    Cell *bottomCell = [self cellBelowCell:cell];
    
    if(bottomCell != nil)
        [adjecentCells addObject:bottomCell];
    
    Cell *leftCell = [self cellLeftOfCell:cell];
    
    if(leftCell != nil)
        [adjecentCells addObject:leftCell];
    
    Cell *rightCell = [self cellRightOfCell:cell];
    
    if(rightCell != nil)
        [adjecentCells addObject:rightCell];
    
    return adjecentCells;
}

- (NSArray *) adjectLiveCellsForCell: (Cell *) cell
{
    NSArray *adjectCells = [self adjacentCellsForCell:cell];
    
    NSMutableArray *liveCells = [[NSMutableArray alloc]initWithCapacity:8];
    
    for(Cell *cell in adjectCells)
    {
        if([RJCellLayer cellIsAlive:cell])
        {
            [liveCells addObject:cell];
        }
    }
    
    adjectCells = nil;
    
    return liveCells;
}

- (NSArray *) adjacentDeadCells: (Cell *) cell
{
    NSArray *adjectCells = [self adjacentCellsForCell:cell];
    
    NSMutableArray *deadCells = [[NSMutableArray alloc]initWithCapacity:8];
    
    for(Cell *cell in adjectCells)
    {
        if(![RJCellLayer cellIsAlive:cell])
        {
            [deadCells addObject:cell];
        }
    }
    
    adjectCells = nil;
    
    return deadCells;
}

+ (RJLiveCell *) liveCell
{
    RJLiveCell *newLiveCell = [[RJLiveCell alloc] init];
    
    return newLiveCell;
}

+ (RJDeadCell *) deadCell
{
    RJDeadCell *newDeadCell = [[RJDeadCell alloc] init];
    
    return newDeadCell;
}



- (NSInteger) liveCountForCell: (Cell *) cell
{
    NSArray *liveCells = [self adjectLiveCellsForCell:cell];
    
    return liveCells.count;
}

- (void) replaceCellWithCounterpart: (Cell *) cell
{
    if([RJCellLayer cellIsAlive:cell])
    {
        RJDeadCell *deadCell = [RJCellLayer deadCell];
        
        deadCell.position = cell.position;
        deadCell.tilePoint = cell.tilePoint;
        
        [self removeChild:cell];
        [self addChild:deadCell];
    }
    else
    {
        RJLiveCell *liveCell = [RJCellLayer liveCell];
        
        liveCell.position = cell.position;
        liveCell.tilePoint = cell.tilePoint;
        
        [self removeChild:cell];
        [self addChild:liveCell];
    }
}

- (void) generateNewGeneration
{
    NSMutableArray *copyChildren = [NSMutableArray arrayWithArray:_children];
    for(Cell *cell in copyChildren)
    {
        NSInteger liveCount = [self liveCountForCell:cell];
        
        if([RJCellLayer cellIsAlive:cell])
        {
            if(liveCount < 2 || liveCount > 3)
            {
                [self replaceCellWithCounterpart:cell];
            }
            else if(liveCount == 2 || liveCount == 3)
            {
                continue;
            }
        }
        else
        {
            if(liveCount == 3)
            {
                [self replaceCellWithCounterpart:cell];
            }
            else
            {
                continue;
            }
        }
    }
}

- (BOOL) validCoordinate: (CGPoint) testCoordinate
{
    if( testCoordinate.x < 0 || testCoordinate.x > _mapSize.width - 1 || testCoordinate.y < 0 || testCoordinate.y > _mapSize.height - 1)
    {
        return false;
    }
    
    return true;
}

- (Cell *) cellatCoordinate: (CGPoint) coordinate
{
    if(![self validCoordinate:coordinate])
    {
        return nil;
    }
    
    for(Cell *childCell in _children)
    {
        if(CGPointEqualToPoint(childCell.tilePoint, coordinate))
        {
            return childCell;
        }
    }
    
    return nil;
}

- (Cell *) cellBelowCell: (Cell *) cell
{
    CGPoint bottomCoordinate = CGPointMake(cell.tilePoint.x - 1, cell.tilePoint.y);
    
    Cell *cellBelow = [self cellatCoordinate:bottomCoordinate];
    
    return cellBelow;
}

- (Cell *) cellAboveCell: (Cell *) cell
{
    CGPoint bottomCoordinate = CGPointMake(cell.tilePoint.x + 1, cell.tilePoint.y);
    
    Cell *cellAbove = [self cellatCoordinate:bottomCoordinate];
    
    return cellAbove;
}

- (Cell *) cellLeftOfCell: (Cell *) cell
{
    CGPoint bottomCoordinate = CGPointMake(cell.tilePoint.x, cell.tilePoint.y - 1);
    
    Cell *cellToLeft = [self cellatCoordinate:bottomCoordinate];
    
    return cellToLeft;
}


- (Cell *) cellRightOfCell: (Cell *) cell
{
    CGPoint bottomCoordinate = CGPointMake(cell.tilePoint.x, cell.tilePoint.y + 1);
    
    Cell *cellToRight = [self cellatCoordinate:bottomCoordinate];
    
    return cellToRight;
}

- (CellEdgeStyle) edgeForCell: (Cell *) cell
{
    CGFloat lastRow = _mapSize.width - 1;
    CGFloat lastCol = _mapSize.height - 1;
    
    CGFloat cellX = cell.tilePoint.x;
    CGFloat cellY = cell.tilePoint.y;
    
    if(cellX == 0)
    {
        //If in first row
        if(cellY == 0)
        {
            return  CellEdgeStyleBottomLeft;
        }
        
        if(cellY == lastCol)
        {
            return CellEdgeStyleBottomRight;
        }
        
        return CellEdgeStyleBotttom;
    }
    
    if(cellX == lastRow)
    {
        //If in last row
        
        if(cellY == 0)
        {
            return CellEdgeStyleTopLeft;
        }
        
        if(cellY == lastCol)
        {
            return CellEdgeStyleTopRight;
        }
        
        return CellEdgeStyleTop;
    }
    
    if(cellY == 0)
    {
        //We are in first column but already did all other checks so this must be left side only
        
        return CellEdgeStyleLeft;
    }
    
    if(cellY == lastCol)
    {
        //We are in last column but already did all other checks so this must be right side only
        
        return CellEdgeStyleRight;
    }
    
    //All other checks failed, this cell is not on the edge
    return CellEdgeStyleNone;
}

+ (RJCellLayer *) cellLayerFromTiledLayer: (CCTiledMapLayer *) tiledMapLayer
{
    RJCellLayer *newCellLayer = [[RJCellLayer alloc] initWithMapSize:tiledMapLayer.layerSize];
    
    for(int i = 0; i < tiledMapLayer.layerSize.width; i++)
    {
        for(int j = 0; j < tiledMapLayer.layerSize.height; j++)
        {
            CCSprite *sprite = [tiledMapLayer tileAt:CGPointMake(i, j)];
            
            RJDeadCell *newDeadCell = [[RJDeadCell alloc] init];
            
            newDeadCell.position = sprite.position;
            
            newDeadCell.name = NSStringFromCGPoint(newDeadCell.position);
            
            newDeadCell.tilePoint = CGPointMake(i, j);
            
            [newCellLayer addChild:newDeadCell];
        }
    }
    
    return newCellLayer;
}

+ (BOOL) cellIsAlive: (Cell *) cell
{
    if([cell isKindOfClass:[RJDeadCell class]])
    {
        return false;
    }
    else
    {
        return true;
    }
}



@end
