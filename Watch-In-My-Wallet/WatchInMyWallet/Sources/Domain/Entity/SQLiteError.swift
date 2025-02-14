//
//  SQLiteError.swift
//  WatchInMyWallet
//
//  Created by Woody on 2/14/25.
//

import Foundation

public enum SQLiteError: Error {
//    notFoundEntity(String),
    case savePostWrite(String), readEntity(String), updatePost(String), deletePost(String)
    
    public var description: String {
        switch self {
//        case .notFoundEntity(let objectName):
//            "객체를 찾을 수 없습니다 : \(objectName)"
        case .savePostWrite(let message):
            "객체 저장 실패 : \(message)"
        case .readEntity(let message):
            "객체 읽기 실패 : \(message)"
        case .updatePost(let message):
            "객체 수정 실패 : \(message)"
        case .deletePost(let message):
            "객체 삭제 실패 : \(message)"
        }
    }
}
