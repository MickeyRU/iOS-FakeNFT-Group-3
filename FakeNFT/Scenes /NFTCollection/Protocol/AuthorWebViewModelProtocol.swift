//
//  AuthorWebViewModel.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 12.09.2023.
//

import Foundation

protocol AuthorWebViewModelProtocol {
    var pageIsLoaded: Bool { get }
    var pageIsLoadedObserve: AuthorWebObservable<Bool> { get }
    var url: URL? { get }
    var urlObserve: AuthorWebObservable<URL?> { get }

    func initialize(url: URL?)
    func setPageIsLoaded(status: Bool)
}
