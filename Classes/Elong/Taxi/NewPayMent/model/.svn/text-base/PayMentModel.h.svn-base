//
//  GetPayProdsResp.h
//  ElongClient
//
//  Created by nieyun on 14-4-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

@interface PaymentProduct : BaseModel
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,assign) NSString  *typeId;
@property (nonatomic,assign)NSString  *tagId;
@property (nonatomic,copy) NSString *productCode;
@property (nonatomic,copy) NSString *productSubCode;
@property (nonatomic,copy) NSString *bankCode;
@property (nonatomic,copy) NSString *bankId;
@property (nonatomic,copy) NSString *categoryId;
@property (nonatomic,copy) NSString *productNameCN;
@property (nonatomic,copy) NSString *productNameEN;
@property (nonatomic,copy) NSString *productShortNameCN;
@property (nonatomic,copy) NSString *productShortNameEN;
@property (nonatomic,copy) NSString *paymentNotesCN;
@property (nonatomic,copy) NSString *paymentNotesEN;
@property (nonatomic,copy) NSString *needCVV2;
@property (nonatomic,copy) NSString *needCardholders;
@property (nonatomic,copy) NSString *needCardholdersPhone;
@property (nonatomic,copy) NSString *needCertificateNo;
@property (nonatomic,copy) NSString *enable;
@property (nonatomic,copy) NSString *outCard;
@property (nonatomic,copy) NSString *needPaymentPassword;
@property (nonatomic,copy) NSString *needPhoneVerificationCode;
@property (nonatomic,copy) NSString *supportCA;
@property (nonatomic,copy) NSString *supportCoupon;
@property (nonatomic,copy) NSString *supportPoint;
@property (nonatomic,copy) NSString *sendType;
@property (nonatomic,copy) NSString *sendEncodingType;
@property (nonatomic,copy) NSString *sendSkipType;
@property (nonatomic,copy) NSString *pageDisplayType;
@property (nonatomic,copy) NSString *pauseEndTime;
@property (nonatomic,copy) NSString *pauseStartTime;
@property (nonatomic,copy) NSString *promptInfoCN;
@property (nonatomic,copy) NSString *promptInfoEN;
@property (nonatomic,copy) NSString  *needexpiredate;
@end

@interface PaymentType : BaseModel
@property  (nonatomic,assign) NSString   *tagId;
@property  (nonatomic,assign) NSString   *typeId;
@property (nonatomic,copy) NSString  *typeNameCN;
@property (nonatomic,copy) NSString  *typeNameEN;
@property (nonatomic,copy) NSString  *typeNoteCN;
@property (nonatomic,copy) NSString  *typeNoteEN;
@property (nonatomic,retain) NSArray   *paymentProducts;
@end


@interface PaymentTag : BaseModel
@property (nonatomic,assign) int  tagId;
@property (nonatomic,copy) NSString  *tagNameCN;
@property (nonatomic,copy) NSString  *tagNameEN;
@property  (nonatomic,retain) NSArray  *paymentTypes;
@end


@interface GetPayProdsResp : BaseModel
@property (nonatomic,assign) BOOL  IsError;
@property (nonatomic,copy) NSString  *ErrorMessage;
@property (nonatomic,copy) NSString  *ErrorCode;
@property (nonatomic,assign) int  paymentProdscount;
@property (nonatomic,retain) NSArray  *paymentTags;
@end





