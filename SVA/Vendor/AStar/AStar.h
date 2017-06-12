//
//  AStar.h
//  TagImageView
//
//  Created by apple on 13-10-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AStarItem.h"

@interface AStar : NSObject
{
    NSInteger curCol, curRow, aimCol, aimRow;
	NSInteger AimX, AimY, AimW, AimH;
//	CCTMXTiledMap* map;
    NSMutableArray *open;
    NSMutableArray *close;
    NSMutableArray *path;
}

@property (strong, nonatomic) NSMutableArray *allPointsArray;//所有路径点集合
@property (strong, nonatomic) NSMutableArray *relationArray;//所有路径点邻接点关系集合

- (NSInteger)getG:(NSInteger)col row:(NSInteger)row fid:(NSInteger)fid;
- (NSInteger)getH:(NSInteger)col row:(NSInteger)row;

- (void)fromOpenToClose;
- (void)removeFromOpen;
- (void)getPath;
- (void)starSearch:(NSInteger)fid withPaths:(NSMutableArray *)paths;

- (void)resetSort:(NSInteger)last;
- (BOOL)checkClose:(NSInteger)col row:(NSInteger)row;
- (void)addToOpen:(NSInteger)col row:(NSInteger)row fid:(NSInteger)fid;
- (BOOL)checkMap:(NSInteger)col row:(NSInteger)row withPaths:(NSMutableArray *)paths;
- (BOOL)checkOpen:(NSInteger)col row:(NSInteger)row fid:(NSInteger)fid;
- (NSMutableArray *)findPath:(NSInteger)curX curY:(NSInteger)curY aimX:(NSInteger)aimX aimY:(NSInteger)aimY withPath:(NSMutableArray *)paths;


//new method
/**
 *  找出邻接点
 *
 *  @param item 该店的邻接点
 *
 *  @return 邻接点集合
 */
- (NSMutableArray *)findNeighborPoints:(AStarItem *const)item;

/**
 *  找出距离设施或人最近的点
 *
 */
- (AStarItem *)findNearestPoint:(NSInteger)col row:(NSInteger)row;

@end
