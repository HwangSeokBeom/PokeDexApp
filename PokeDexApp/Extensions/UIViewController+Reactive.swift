//
//  UIViewController+Reactive.swift
//  PokeDexApp
//
//  Created by 황석범 on 1/19/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in }
    }
}
