//
//  GoodsIcon.h
//  FileTestProject
//
//  Created by LIU YUJIE on 2/5/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"

typedef enum : NSUInteger {
    GoodsIconTypeCityGoods,
    GoodsIconTypeShipGoods,
    GoodsIconTypeSoldGoods,
} GoodsIconType;

typedef enum : NSUInteger {
    ShowBuyPrice,
    ShowLevel,
    ShowCityGoods,
    ShowNewBuyGoods,
} ShowType;

@protocol GoodsIconSelectionDelegate <NSObject>

-(void)selectGoodsIcon:(id)goodsIcon;

@end

@interface GoodsIcon : CCSprite

@property (nonatomic, assign) GoodsIconType goodsType;
@property (nonatomic, assign) int goodsIndex;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, weak) id<GoodsIconSelectionDelegate> delegate;
@property (nonatomic, assign) int newItemIndex;
@property (nonatomic, assign) ShowType type;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) int price;
@property (nonatomic, assign) int buyPrice;
@property (nonatomic, assign) int level;

-(void)setGoods:(NSString *)goodsId price:(int)price level:(int)level buyPrice:(int)buyPrice;;

-(BOOL)isEmpty;  

@end
