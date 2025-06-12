//
//  CaseViewViewVodel.swift
//  customBottomSheet
//
//  Created by dan phi on 21/3/25.
//

class CaseViewViewModel {
    
    var onRetryAction: (() -> Void)?
    var onBackAction: (() -> Void)?
    var onExisteAction: (() -> Void)?
    
    
    func handleRetryAction() {
        onRetryAction?()
    }
    func handleBackAction() {
        onBackAction?()
    }
    func handleExisteAction() {
        onExisteAction?()
    }
}
