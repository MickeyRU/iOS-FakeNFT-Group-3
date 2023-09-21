//
//  AuthorWebViewModel.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 12.09.2023.
//

import Foundation

final class AuthorWebViewModel: AuthorWebViewModelProtocol {
    @AuthorWebObservable
    private(set) var pageIsLoaded: Bool = false
    var pageIsLoadedObserve: AuthorWebObservable<Bool> { $pageIsLoaded }

    @AuthorWebObservable
    private(set) var url: URL?
    var urlObserve: AuthorWebObservable<URL?> { $url }

    func initialize(url: URL?) {
        self.url = url
    }

    func setPageIsLoaded(status: Bool) {
        pageIsLoaded = status
    }

}
