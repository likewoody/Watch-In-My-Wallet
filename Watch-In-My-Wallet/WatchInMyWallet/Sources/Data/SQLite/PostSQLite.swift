//
//  PostSQLite.swift
//  WatchInMyWallet
//
//  Created by Woody on 2/14/25.
//

import Combine
import SQLite3
import Foundation

public protocol PostSQLiteProtocol {
    func createPost(dateID: Int, categoryID: Int, title: String, memo: String, account: String, amount: Int) -> AnyPublisher<Bool, SQLiteError>
    func readPost() -> AnyPublisher<[Post], SQLiteError>
    func updatePost(id: Int, dateID: Int, categoryID: Int, title: String, memo: String, account: String, amount: Int) -> AnyPublisher<Bool, SQLiteError>
    func deletePost(id: Int) -> AnyPublisher<Bool, SQLiteError>
}

public struct PostSQLite: PostSQLiteProtocol {
    
    init() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: "watchInMyWallet.sqlite")
        
        // File이 있다면
        if sqlite3_open(fileURL.path(percentEncoded: true), &db) != SQLITE_OK {
            print("error opening database")
        }
        
        makeTables()
    }
    
    public func createPost(dateID: Int, categoryID: Int, title: String, memo: String, account: String, amount: Int) -> AnyPublisher<Bool, SQLiteError> {
        let stmt: OpaquePointer?
        
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "INSERT INTO students (sname, sdept, sphone) VALUES (?,?,?)"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
        sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 2, dept, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(stmt, 3, phone, -1, SQLITE_TRANSIENT)
        
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return Just(true)
                .setFailureType(to: SQLiteError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: SQLiteError.savePostWrite("save Error")).eraseToAnyPublisher()
        }
    }
    
    public func readPost() -> AnyPublisher<[Post], SQLiteError> {
        <#code#>
    }
    
    public func updatePost(id: Int, dateID: Int, categoryID: Int, title: String, memo: String, account: String, amount: Int) -> AnyPublisher<Bool, SQLiteError> {
        <#code#>
    }
    
    public func deletePost(id: Int) -> AnyPublisher<Bool, SQLiteError> {
        <#code#>
    }

    
    // MARK: Making init tables
    private func makeTables() {
        // Date Table 만들기
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS PostDate(id INTEGER PRIMARY KEY AUTOINCREMENT, setType TEXT, postDate TEXT)", nil, nil, nil) != SQLITE_OK {
            // error message c언어 스트링
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating PostDate table\ncode : \(errMsg)")
        }
        
        // Category Table 만들기
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Category(id INTEGER PRIMARY KEY AUTOINCREMENT, categoryName TEXT)", nil, nil, nil) != SQLITE_OK {
            // error message c언어 스트링
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating Cateogry table\ncode : \(errMsg)")
        }
        
        // Post Table 만들기
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Post(id INTEGER PRIMARY KEY AUTOINCREMENT, dateID INTEGER, categoryID INTEGER, title TEXT, memo TEXT, amount TEXT, account TEXT)", nil, nil, nil) != SQLITE_OK {
            // error message c언어 스트링
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating Post table\ncode : \(errMsg)")
        }
        
        // Write Table 만들기
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Post(id INTEGER PRIMARY KEY AUTOINCREMENT, postID INTEGER)", nil, nil, nil) != SQLITE_OK {
            // error message c언어 스트링
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating Post Write table\ncode : \(errMsg)")
        }
    }
    
}
