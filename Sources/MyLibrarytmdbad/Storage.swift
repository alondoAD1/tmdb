//
//  Storage.swift
//  tmdbtest
//
//  Created by A on 05/12/21.
//

import Foundation
import RNCryptor

public class Storage {
    
    public static let userKeyDefault       = "userKeyDefault"
    private static let passworKeyDefault    = "passworKeyDefault"
    private static let requestKeyDefault    = "requestKeyDefault"
    private static let sessionIDKeyDefault  = "sessionIDKeyDefault"
    private static let userIDKeyDefault     = "userIDKeyDefault"
    
    private static var userDefaults: UserDefaults {
        UserDefaults.standard
    }
    
    public static var username: String {
        get { return self.userDefaults.string(forKey: self.userKeyDefault) ?? "" }
        set { self.userDefaults.set(newValue, forKey: self.userKeyDefault) }
    }
    
    public static var password: String {
        get { return self.userDefaults.string(forKey: self.passworKeyDefault) ?? "" }
        set { self.userDefaults.set(newValue, forKey: self.passworKeyDefault) }
    }
    
    public static var token: String {
        get { return self.userDefaults.string(forKey: self.requestKeyDefault) ?? "" }
        set { self.userDefaults.set(newValue, forKey: self.requestKeyDefault) }
    }
    
    public static var sessionID: String {
        get { return self.userDefaults.string(forKey: self.sessionIDKeyDefault) ?? "" }
        set { self.userDefaults.set(newValue, forKey: self.sessionIDKeyDefault) }
    }
    
    public static var userID: String {
        get { return self.userDefaults.string(forKey: self.userIDKeyDefault) ?? "" }
        set { self.userDefaults.set(newValue, forKey: self.userIDKeyDefault) }
    }
    
    public static func deleteStorage() {
        let def = UserDefaults.standard
        def.removeObject(forKey: self.userKeyDefault)
        def.removeObject(forKey: self.passworKeyDefault)
        def.removeObject(forKey: self.requestKeyDefault)
        def.removeObject(forKey: self.sessionIDKeyDefault)
        def.removeObject(forKey: self.userIDKeyDefault)
        UserDefaults.standard.synchronize()

    }
    
}
