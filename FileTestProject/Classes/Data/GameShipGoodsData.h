//
//  GameShipGoodsData.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/6/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameShipGoodsData : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *goodsId;
@property (nonatomic, readonly) int price;
@property (nonatomic, readonly) int level;
@property (nonatomic, assign) int newItemIndex;

-(instancetype)initWithGoodsId:(NSString *)goodsId price:(int)price level:(int)level;

-(void)setGoodsId:(NSString *)goodsId price:(int)price level:(int)level;

@end
