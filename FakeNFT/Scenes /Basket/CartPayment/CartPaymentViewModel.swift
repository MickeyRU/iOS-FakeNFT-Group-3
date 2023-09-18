//
//  CartPaymentViewModel.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 11.09.2023.
//

import Foundation

public protocol CartPaymentViewModelProtocol {
    var currencies: Box<CurrenciesViewModel> { get }
    var cartPaymentViewState: Box<CartPaymentViewModel.ViewState> { get }
    var purchaseState: Box<CartPaymentViewModel.PurchaseState> { get }
    var error: Box<Error?> { get }
    var selectedCurrencyId: Box<String?> { get }

    func fetchCurrencies()
    func purсhase()
}

public final class CartPaymentViewModel {
    public enum PurchaseState {
        case success
        case failure
        case didNotHappen
    }

    public let currencies = Box<CurrenciesViewModel>([])
    public let cartPaymentViewState = Box<ViewState>(.loading)
    public let purchaseState = Box<PurchaseState>(.didNotHappen)
    public let error = Box<Error?>(nil)
    public let selectedCurrencyId = Box<String?>(nil)

    private let orderId: String

    private lazy var successFetchCompletion: LoadingCompletionBlock<ViewState> = { [weak self] viewState in
        if case .loaded(let currencies) = viewState {
            guard let self, let currencies else { return }
            self.cartPaymentViewState.value = viewState
            self.currencies.value = currencies
        }
    }

    private lazy var purchaseCompletion: LoadingCompletionBlock<PurchaseState> = { [weak self] purchaseState in
        guard let self else { return }
        self.cartPaymentViewState.value = .loaded(nil)
        self.purchaseState.value = purchaseState
    }

    private lazy var failureCompletion: LoadingFailureCompletionBlock = { [weak self] error in
        guard let self else { return }
        self.error.value = error
        self.cartPaymentViewState.value = .empty
    }

    private let cartPaymentInteractor: CartPaymentViewInteractorProtocol

    init(orderId: String, interactor: CartPaymentViewInteractorProtocol) {
        self.orderId = orderId
        self.cartPaymentInteractor = interactor
    }
}

// MARK: - CartPaymentViewModelProtocol

extension CartPaymentViewModel: CartPaymentViewModelProtocol {
    public func fetchCurrencies() {
        if cartPaymentViewState.value != .loading {
            cartPaymentViewState.value = .loading
        }

        cartPaymentInteractor.fetchCurrencies(
            onSuccess: successFetchCompletion,
            onFailure: failureCompletion
        )
    }

    public func purсhase() {
        guard let selectedCurrencyId = selectedCurrencyId.value else { return }
        cartPaymentViewState.value = .loading
        cartPaymentInteractor.purchase(
            orderId: orderId,
            currencyId: selectedCurrencyId,
            onSuccess: purchaseCompletion,
            onFailure: failureCompletion
        )
    }
}
