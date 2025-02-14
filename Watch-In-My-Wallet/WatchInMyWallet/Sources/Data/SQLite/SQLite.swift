//
//  SQLiteInit.swift
//  WatchInMyWallet
//
//  Created by Woody on 2/14/25.
//

import Foundation
import SQLite3
import Combine

public protocol SQLiteProtocol {
    var db: OpaquePointer? { get }
    var fileURL: URL { get }
    var tableName: String { get set }
    var attributes: String { get set }
    func checkFileExiste() -> Bool
    func makeTable()
    func deleteItem(id: Int) -> AnyPublisher<Bool, SQLiteError>
}

public class SQLite: SQLiteProtocol {
    public var db: OpaquePointer?
//    static let shared = SQLite()
    public let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: "watchInMyWallet.sqlite")
    
    public var tableName: String
    public var attributes: String
    
    init(db: OpaquePointer? = nil, tableName: String, attributes: String) {
        self.db = db
        self.tableName = tableName
        self.attributes = attributes
    }
    
    public func checkFileExiste() -> Bool {
        if sqlite3_open(fileURL.path(percentEncoded: true), &db) != SQLITE_OK {
            return true
        }
        return false
    }
    
    public func makeTable() {
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS \(tableName)(id INTEGER PRIMARY KEY AUTOINCREMENT, \(attributes)", nil, nil, nil) != SQLITE_OK {
            // error message c언어 스트링
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating \(tableName) table\ncode : \(errMsg)")
        }
    }
    
    public func deleteItem(id: Int) -> AnyPublisher<Bool, SQLiteError> {
        var stmt: OpaquePointer?
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
//        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "DELETE FROM \(tableName) WHERE id = ?"

        sqlite3_prepare(db, queryString, -1, &stmt, nil)

        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
        sqlite3_bind_int(stmt, 1, Int32(id))


        if sqlite3_step(stmt) == SQLITE_DONE {
            return Just(true)
                .setFailureType(to: SQLiteError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: SQLiteError.deletePost("\(tableName) Delete ERROR")).eraseToAnyPublisher()
        }
    }
}


