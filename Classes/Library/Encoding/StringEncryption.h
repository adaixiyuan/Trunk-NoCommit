//
//  StringEncryption.h
//
//  Created by DAVID VEKSLER on 2/4/09.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


#define kChosenCipherBlockSize	kCCBlockSizeAES128
#define kChosenCipherKeySize	kCCKeySizeAES128
#define kChosenDigestLength		CC_SHA1_DIGEST_LENGTH

#define kElongCreditCardKey		@"1234567891123456"
//#define kElongCreditCardKey		@"1234567890123456"

@interface StringEncryption : NSObject

+ (NSString *) EncryptString:(NSString *)plainSourceStringToEncrypt;
+ (NSString *)EncryptString:(NSString *)plainSourceStringToEncrypt byKey:(NSString *)cutomKey;
+ (NSString *) DecryptString:(NSString *) base64StringToDecrypt;
+ (NSString *)DecryptString:(NSString *)base64StringToDecrypt byKey:(NSString *)cutomKey;

- (NSData *)encrypt:(NSData *)plainText key:(NSData *)aSymmetricKey padding:(CCOptions *)pkcs7;
- (NSData *)decrypt:(NSData *)plainText key:(NSData *)aSymmetricKey padding:(CCOptions *)pkcs7;

- (NSData *)doCipher:(NSData *)plainText key:(NSData *)aSymmetricKey
			 context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7;

@end
