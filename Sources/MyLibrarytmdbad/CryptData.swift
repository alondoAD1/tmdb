//
//  CryptData.swift
//  tmdbtest
//
//  Created by A on 05/12/21.
//

import Foundation
import RNCryptor

class CryptData {
    
    public func encrypt(textEncrypt: String) -> String {
        let data: Data = textEncrypt.data(using: .utf8)!
        let encruptedData = RNCryptor.encrypt(data: data, withPassword: "xDnMQpKDSREksd342JKS")
        let encryptedString: String = encruptedData.base64EncodedString()
        return encryptedString
    }
    
    public func decrypt(oncryptedText: String) -> String {
        let mensaje = "Error al desencriptar"
        do {
            let data: Data = Data(base64Encoded: oncryptedText)!
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: "xDnMQpKDSREksd342JKS")
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            return decryptedString ?? ""
        } catch {
            return mensaje
        }
                
    }
    
    
}
