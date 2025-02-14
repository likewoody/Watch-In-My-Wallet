//
//  CateogrySQLite.swift
//  WatchInMyWallet
//
//  Created by Woody on 2/14/25.
//

import Foundation
import Combine
import SQLite3

public protocol CategorySQLiteProtocol {
    func create(setType: String) -> AnyPublisher<Bool, SQLiteError>
    func read() -> AnyPublisher<[Category], SQLiteError>
    func update(id: Int, categoryName: String) -> AnyPublisher<Bool, SQLiteError>
    func delete(id: Int) -> AnyPublisher<Bool, SQLiteError>
}

public struct CategorySQLite: CategorySQLiteProtocol {
    private let sqlite: SQLiteProtocol
    
    init() {
        // File이 있다면
        sqlite = SQLite(tableName: "category", attributes: "categoryName TEXT")
        if sqlite.checkFileExiste() {
            print("error opening database")
        }
        sqlite.makeTable()
    }
    public func create(setType: String) -> AnyPublisher<Bool, SQLiteError> {
        var stmt: OpaquePointer?
        
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "INSERT INTO \(sqlite.tableName) (categoryName) VALUES (?)"
        
        sqlite3_prepare(sqlite.db, queryString, -1, &stmt, nil)
        
        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
        sqlite3_bind_text(stmt, 1, setType, -1, SQLITE_TRANSIENT)
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return Just(true)
                .setFailureType(to: SQLiteError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: SQLiteError.savePostWrite("\(sqlite.tableName) Save ERROR")).eraseToAnyPublisher()
        }
    }
    
    public func read() -> AnyPublisher<[Category], SQLiteError> {
        var stmt: OpaquePointer?
        var itemList: [Category] = []
        let queryString = "SELECT * FROM \(sqlite.tableName)"
        
        // 에러가 발생하는지 확인하기 위해서 if문 사용
        // -1 unlimit length 데이터 크기를 의미한다
        if sqlite3_prepare(sqlite.db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(sqlite.db)!)
            print("error creating \(sqlite.tableName) table\ncode : \(errMsg)")
            return Fail(error: SQLiteError.readEntity("\(sqlite.tableName) Error")).eraseToAnyPublisher()
        }
        // 불러올 데이터가 있다면 불러온다.
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(stmt, 0))
            let categoryName = String(cString: sqlite3_column_text(stmt, 1))
            
            itemList.append(Category(id: id, categoryName: categoryName))
        }
        
        return Just(itemList)
            .setFailureType(to: SQLiteError.self)
            .eraseToAnyPublisher()
    }
    
    public func update(id: Int, categoryName: String) -> AnyPublisher<Bool, SQLiteError> {
        var stmt: OpaquePointer?
                
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "UPDATE \(sqlite.tableName) SET categoryName = ? WHERE id = ?"
        
        sqlite3_prepare(sqlite.db, queryString, -1, &stmt, nil)
        
        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
        sqlite3_bind_text(stmt, 1, categoryName, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 2, Int32(id))
        
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            
            return Just(true)
                .setFailureType(to: SQLiteError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: SQLiteError.updatePost("\(sqlite.tableName) Update ERROR")).eraseToAnyPublisher()
        }
    }
    
    public func delete(id: Int) -> AnyPublisher<Bool, SQLiteError> {
        sqlite.deleteItem(id: id)
    }
}
