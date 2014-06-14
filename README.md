Game-of-Life--iOS
=================

iOS implementation of Conway's Game of Life using the Cocos2d Engine


Right now this is very early version. The game will start working as soon as you launch app.



The game has 10 x 10 tiles. The placement of the tiles in the beginning is created based off the TestMap.tmx file.

Tiles in this app are represented using "Cells". Thus, we have the Cell object. We have two subclasses, RJDeadCell and RJLiveCell.

These are subclasses of the Cell object.


All cells are placed and handled by the RJCellLayer.
After the RJCellLayer has been initialized with all dead cells, randomly, the board is filled with live tiles. 


Finally we continuously apply the rules of the Game of Life to generate new live and dead tiles.
