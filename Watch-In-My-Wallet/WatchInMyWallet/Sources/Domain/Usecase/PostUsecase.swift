//
//  PostUsecase.swift
//  WatchInMyWallet
//
//  Created by Woody on 2/14/25.
//

import Combine

public protocol PostUsecaseProtocol {
    // CRUD
    func createPost(dateID: Int, categoryID: Int, title: String, memo: String, account: String, amount: Int) -> AnyPublisher<Bool, SQLiteError>
    func readPost() -> AnyPublisher<[Post], SQLiteError>
    func updatePost(id: Int, dateID: Int, categoryID: Int, title: String, memo: String, account: String, amount: Int) -> AnyPublisher<Bool, SQLiteError>
    func deletePost(id: Int) -> AnyPublisher<Bool, SQLiteError>
}
public struct PostUsecase: PostUsecaseProtocol {
    
    let postRepository: PostRepositoryProtocol
    
    init(postRepository: PostRepositoryProtocol) {
        self.postRepository = postRepository
    }
    
    public func createPost(dateID: Int, categoryID: Int, title: String, memo: String, account: String, amount: Int) -> AnyPublisher<Bool, SQLiteError> {
        postRepository.createPost(dateID: dateID, categoryID: categoryID, title: title, memo: memo, account: account, amount: amount)
    }
    
    public func readPost() -> AnyPublisher<[Post], SQLiteError> {
        postRepository.readPost()
    }
    
    public func updatePost(id: Int, dateID: Int, categoryID: Int, title: String, memo: String, account: String, amount: Int) -> AnyPublisher<Bool, SQLiteError> {
        postRepository.updatePost(id: id, dateID: dateID, categoryID: categoryID, title: title, memo: memo, account: account, amount: amount)
    }
    
    public func deletePost(id: Int) -> AnyPublisher<Bool, SQLiteError> {
        postRepository.deletePost(id: id)
    }
}
