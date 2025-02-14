//
//  PostRepository.swift
//  WatchInMyWallet
//
//  Created by Woody on 2/14/25.
//

import Combine

public protocol PostRepositoryProtocol {
    func createPost(dateID: Int, categoryID: Int, title: String, memo: String, account: String, amount: Int) -> AnyPublisher<Bool, SQLiteError>
    func readPost() -> AnyPublisher<[Post], SQLiteError>
    func updatePost(id: Int, dateID: Int, categoryID: Int, title: String, memo: String, account: String, amount: Int) -> AnyPublisher<Bool, SQLiteError>
    func deletePost(id: Int) -> AnyPublisher<Bool, SQLiteError>
}

public struct PostRepository: PostRepositoryProtocol {
    
    let sqlite: PostSQLiteProtocol
    
    init(sqlite: PostSQLiteProtocol) {
        self.sqlite = sqlite
    }
    
    public func createPost(dateID: Int, categoryID: Int, title: String, memo: String, account: String, amount: Int) -> AnyPublisher<Bool, SQLiteError> {
        sqlite.createPost(dateID: dateID, categoryID: categoryID, title: title, memo: memo, account: account, amount: amount)
    }
    
    public func readPost() -> AnyPublisher<[Post], SQLiteError> {
        sqlite.readPost()
    }
    
    public func updatePost(id: Int, dateID: Int, categoryID: Int, title: String, memo: String, account: String, amount: Int) -> AnyPublisher<Bool, SQLiteError> {
        sqlite.updatePost(id: id, dateID: dateID, categoryID: categoryID, title: title, memo: memo, account: account, amount: amount)
    }
    
    public func deletePost(id: Int) -> AnyPublisher<Bool, SQLiteError> {
        sqlite.deletePost(id: id)
    }
}


