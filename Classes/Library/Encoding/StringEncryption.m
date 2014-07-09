//
//  StringEncryption.m
//
//  Created by DAVID VEKSLER on 2/4/09.
//

#import "StringEncryption.h"
#import "NSData+Base64.h"

#if DEBUG
#define LOGGING_FACILITY(X, Y)	\
NSAssert(X, Y);	

#define LOGGING_FACILITY1(X, Y, Z)	\
NSAssert1(X, Y, Z);	
#else
#define LOGGING_FACILITY(X, Y)	\
if(!(X)) {			\
NSLog(Y);		\
exit(-1);		\
}					

#define LOGGING_FACILITY1(X, Y, Z)	\
if(!(X)) {				\
NSLog(Y, Z);		\
exit(-1);			\
}						
#endif

@implementation StringEncryption

CCOptions padding = kCCOptionPKCS7Padding;

+ (NSString *) EncryptString:(NSString *)plainSourceStringToEncrypt
{
	StringEncryption *crypto = [[[StringEncryption alloc] init] autorelease];
	NSData *_secretData = [plainSourceStringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
	NSData *encryptedData = [crypto encrypt:_secretData key:[kElongCreditCardKey dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
	return [encryptedData base64EncodingWithLineLength:0];
}


+ (NSString *)EncryptString:(NSString *)plainSourceStringToEncrypt byKey:(NSString *)customKey
{
	StringEncryption *crypto = [[[StringEncryption alloc] init] autorelease];
	NSData *_secretData = [plainSourceStringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
	NSData *encryptedData = [crypto encrypt:_secretData key:[customKey dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
	return [encryptedData base64EncodingWithLineLength:0];
}


+ (NSString *)DecryptString:(NSString *)base64StringToDecrypt
{
	StringEncryption *crypto = [[[StringEncryption alloc] init] autorelease];
	NSData *data = [crypto decrypt:[NSData dataWithBase64EncodedString:base64StringToDecrypt] key:[kElongCreditCardKey dataUsingEncoding:NSUTF8StringEncoding] padding: &padding];
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}


+ (NSString *)DecryptString:(NSString *)base64StringToDecrypt byKey:(NSString *)cutomKey
{
	StringEncryption *crypto = [[[StringEncryption alloc] init] autorelease];
	NSData *data = [crypto decrypt:[NSData dataWithBase64EncodedString:base64StringToDecrypt] key:[cutomKey dataUsingEncoding:NSUTF8StringEncoding] padding: &padding];
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}


- (NSData *)encrypt:(NSData *)plainText key:(NSData *)aSymmetricKey padding:(CCOptions *)pkcs7
{
    return [self doCipher:plainText key:aSymmetricKey context:kCCEncrypt padding:pkcs7];
}

- (NSData *)decrypt:(NSData *)plainText key:(NSData *)aSymmetricKey padding:(CCOptions *)pkcs7
{
    return [self doCipher:plainText key:aSymmetricKey context:kCCDecrypt padding:pkcs7];
}

- (NSData *)doCipher:(NSData *)plainText key:(NSData *)aSymmetricKey
			 context:(CCOperation)encryptOrDecrypt padding:(CCOptions *)pkcs7
{
    CCCryptorStatus ccStatus = kCCSuccess;
    // Symmetric crypto reference.
    CCCryptorRef thisEncipher = NULL;
    // Cipher Text container.
    NSData * cipherOrPlainText = nil;
    // Pointer to output buffer.
    uint8_t * bufferPtr = NULL;
    // Total size of the buffer.
    size_t bufferPtrSize = 0;
    // Remaining bytes to be performed on.
    size_t remainingBytes = 0;
    // Number of bytes moved to buffer.
    size_t movedBytes = 0;
    // Length of plainText buffer.
    size_t plainTextBufferSize = 0;
    // Placeholder for total written.
    size_t totalBytesWritten = 0;
    // A friendly helper pointer.
    uint8_t * ptr;
	
    // Initialization vector; dummy in this case 0's.
    uint8_t iv[kChosenCipherBlockSize];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
	
    plainTextBufferSize = [plainText length];
	
    // Create and Initialize the crypto reference.
    ccStatus = CCCryptorCreate(encryptOrDecrypt,
                               kCCAlgorithmAES128,
                               *pkcs7,
                               (const void *)[aSymmetricKey bytes],
                               kChosenCipherKeySize,
                               (const void *)iv,
                               &thisEncipher
                               );
	
    // Calculate byte block alignment for all calls through to and including final.
    bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
	
    // Allocate buffer.
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
	
    // Zero out buffer.
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
	
    // Initialize some necessary book keeping.
	
    ptr = bufferPtr;
	
    // Set up initial size.
    remainingBytes = bufferPtrSize;
	
    // Actually perform the encryption or decryption.
    ccStatus = CCCryptorUpdate(thisEncipher,
                               (const void *) [plainText bytes],
                               plainTextBufferSize,
                               ptr,
                               remainingBytes,
                               &movedBytes
                               );
	
    ptr += movedBytes;
    remainingBytes -= movedBytes;
    totalBytesWritten += movedBytes;
	
    ccStatus = CCCryptorFinal(thisEncipher,
                              ptr,
                              remainingBytes,
                              &movedBytes
                              );
	
    totalBytesWritten += movedBytes;
	
    if(thisEncipher) {
        (void) CCCryptorRelease(thisEncipher);
        thisEncipher = NULL;
    }
	
    if (ccStatus == kCCSuccess)
        cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
    else
        cipherOrPlainText = nil;
	
    if(bufferPtr) free(bufferPtr);

    return cipherOrPlainText;
}


@end
