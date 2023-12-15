//
//  KeychainManager.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/4/23.
//

//helper to use keyChain
import Foundation

import Security

class SecureStore {
    private func setupQueryDictionary(forKey key: String) throws -> [CFString: Any] {
        guard let keyData = key.data(using: .utf8) else {
            print("Error! Cannot convert the key to the expected format")
            throw SecureStoreError.invalidContent
        }
        
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrAccount: keyData]
        
        
        return query
    }
    
    func set(entry: String, forKey key: String) throws {
        guard !entry.isEmpty && !key.isEmpty else {
            print("Cant add an empty string to the keychain")
            throw SecureStoreError.queryEmptyWhenSet
        }
        
        try removeEntry(forKey: key)
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "_passwordForFacebook",
            kSecAttrTokenID: "" as String
        ] as CFDictionary
        
        
        var queryDictionary = try setupQueryDictionary(forKey: key)
        queryDictionary[kSecValueData] = entry.data(using: .utf8)
        
        let status = SecItemAdd(queryDictionary as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            print("status ==> ", status.description)
            
            throw SecureStoreError.failureOnWrite(status)
        }
    }
    
    func removeEntry(forKey key: String) throws {
        guard !key.isEmpty else {
            print("key must be valid")
            throw SecureStoreError.queryEmptyWhenDelete
        }
        
        let queryDictionary = try setupQueryDictionary(forKey: key)
        SecItemDelete(queryDictionary as CFDictionary)
        
    }
    
    func getEntry(forKey key: String) throws -> String? {
        guard !key.isEmpty else {
            print("key must be valid")
            throw SecureStoreError.invalidContent
        }
        
        var queryDictionary = try setupQueryDictionary(forKey: key)
        queryDictionary[kSecReturnData] = kCFBooleanTrue
        queryDictionary[kSecMatchLimit] = kSecMatchLimitOne
        
        var data: AnyObject?
        
        let status = SecItemCopyMatching(queryDictionary as CFDictionary, &data)
        
        guard status == errSecSuccess else {
            print("status ==> ", status)
            throw SecureStoreError.failureOnRead(status)
        }
        
        guard let itemData = data as? Data, let result = String(data: itemData, encoding: .utf8) else {
            return nil
        }
        
        return result
    }
}


enum SecureStoreError: Error {
    case invalidContent
    case queryEmptyWhenSet
    case queryEmptyWhenDelete
    case failureOnWrite(OSStatus)
    case failureOnRead(OSStatus)
}

extension SecureStoreError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidContent:
            return NSLocalizedString("Cannot convert to the .utf8 format", comment: "")
        case .queryEmptyWhenSet:
            return NSLocalizedString("for set(:,:), parameters cannot be empty ", comment: "")
        case .queryEmptyWhenDelete:
            return NSLocalizedString("for removeEntry(:,:), parameters cannot be empty ", comment: "")
        case .failureOnWrite(let status):
            return NSLocalizedString("Error when write to keychain item \(status.description)", comment: "")
        case .failureOnRead(let status):
            return NSLocalizedString("Error when read to keychain item \(status.description)", comment: "")
        }
    }
}

//caller

func test() {
    let security = SecureStore.init()

    do {

        try security.set(entry: "myPassword12345.12345", forKey: "_passwordForFacebook")

        //to get value
        let password = try security.getEntry(forKey: "_passwordForFacebook")
        

        print("password > ", password  )

    } catch {
        print("error > ", error.localizedDescription)
    }
}


