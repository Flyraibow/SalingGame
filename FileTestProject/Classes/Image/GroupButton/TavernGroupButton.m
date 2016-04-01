//
//  TavernGroupButton.m
//  FileTestProject
//
//  Created by LIU YUJIE on 2/4/16.
//  Copyright © 2016 Yujie Liu. All rights reserved.
//

#import "TavernGroupButton.h"
#import "DefaultButton.h"
#import "LocalString.h"
#import "BGImage.h"

@implementation TavernGroupButton

-(instancetype)init
{
    DefaultButton *btnDrink = [DefaultButton buttonWithTitle:getLocalString(@"tavern_drink")];
    DefaultButton *btnBuyDrink = [DefaultButton buttonWithTitle:getLocalString(@"tavern_buy_drink")];
    DefaultButton *btnHire = [DefaultButton buttonWithTitle:getLocalString(@"tavern_hire")];
    DefaultButton *btnSpread = [DefaultButton buttonWithTitle:getLocalString(@"tavern_spread")];
    self = [super initWithNSArray:[NSArray arrayWithObjects:btnDrink,btnBuyDrink,btnHire,btnSpread, nil] CCNodeColor:[BGImage getShadowForBackground]];
    if (self) {
        [btnDrink setTarget:self selector:@selector(clickDrinkBtn)];
        [btnBuyDrink setTarget:self selector:@selector(clickBuyDrinkBtn)];
        [btnHire setTarget:self selector:@selector(clickHireBtn)];
        [btnSpread setTarget:self selector:@selector(clickSpreadBtn)];
    }
    return self;
}

-(void)clickDrinkBtn
{
    
}

-(void)clickBuyDrinkBtn
{
    
}

-(void)chooseHireIndex:(int)index
{
    self.visible = YES;
    if (index == 0) {
        
    } else if (index == 1) {
        
    } else {
        
    }
}


-(void)clickSpreadBtn
{
    
}
@end
