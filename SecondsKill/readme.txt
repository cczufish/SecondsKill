/* 
  readme.strings
  SecondsKill

  Created by lijingcheng on 13-11-6.
  Copyright (c) 2013年 edouglas. All rights reserved.
*/

二、修改过以下第三方框架，如果该框架不小心更新了代码，则需要按下面内容重新修改

1､YLProgressBar
    (1)、修改- (void)drawRect:(CGRect)rect方法，这样bar上的文字才能够显示在bar的底色区域：
        将“drawTrack“和“drawText“放到“drawProgressBar“之后去做
    (2)､修改- (void)drawProgressBar:(CGContextRef)context withRect:(CGRect)rect方法，取消颜色渐近效果：
        for (int i = 0; i < colorCount; i++)
        {
            //locations[i] = delta * i + semi_delta;
            locations[i] = 0;
        }
        
2､AES256
    (1)、修改"AESCrypt.m"中的"+ (NSString *)encrypt:password:"方法，对password转码后不用"SHA256Hash"
    (2)、修改"AESCrypt.m"中的"+ (NSString *)decrypt:password:"方法，对password转码后不用"SHA256Hash"
    (3)、修改"NSData (CommonCryptor).m"中的"- (NSData *) dataEncryptedUsingAlgorithm:key:initializationVector:options:error:"方法
        将"CCCryptorCreate( kCCEncrypt, algorithm, options,[keyData bytes], [keyData length], [ivData bytes],&cryptor );"修改成
        "CCCryptorCreate( kCCEncrypt, algorithm, options,[keyData bytes], MIN([keyData length], 16), [ivData bytes],&cryptor );"
    (4)、修改"NSData (CommonCryptor).m"中的"- (NSData *) decryptedDataUsingAlgorithm:key:initializationVector:options:error:"方法
        将"CCCryptorCreate( kCCEncrypt, algorithm, options,[keyData bytes], [keyData length], [ivData bytes],&cryptor );"修改成
        "CCCryptorCreate( kCCEncrypt, algorithm, options,[keyData bytes], MIN([keyData length], 16), [ivData bytes],&cryptor );"
    (5)、修改"NSData (CommonCryptor).m"中的"- (NSData *)AES256EncryptedDataUsingKey:error:"方法
        将"[self dataEncryptedUsingAlgorithm: kCCAlgorithmAES128 key: key options: kCCOptionPKCS7Padding error: &status];"修改成
        "[self dataEncryptedUsingAlgorithm: kCCAlgorithmAES128 key: key options: kCCOptionPKCS7Padding|kCCOptionECBMode error: &status];"
    (6)、修改"NSData (CommonCryptor).m"中的"- (NSData *)decryptedAES256DataUsingKey:error:"方法
        将"[self decryptedDataUsingAlgorithm: kCCAlgorithmAES128 key: key options: kCCOptionPKCS7Padding error: &status];"修改成
        "[self decryptedDataUsingAlgorithm: kCCAlgorithmAES128 key: key options: kCCOptionPKCS7Padding|kCCOptionECBMode error: &status];"
        
