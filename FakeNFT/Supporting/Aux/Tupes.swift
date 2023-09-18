//
//  Tupes.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 30.08.2023.
//

import Foundation

public typealias ActionCallback<T> = (T) -> Void
public typealias LoadingCompletionBlock<T> = (T) -> Void
public typealias LoadingFailureCompletionBlock = (Error) -> Void
public typealias ResultHandler<T> = (Result<T, Error>) -> Void
