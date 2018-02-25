//
//  UIAlertController+Reactive.swift
//  TodoListClient
//
//  Created by Ofir Ben-Tzur on 25/02/2018.
//  Copyright © 2018 Oren Idan. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result


struct Action {
    let label: String
}

//@@ofirbt - delete?

extension UIAlertController {
    static func create(title: String, message: String, actions: [Action], presenter: UIAlertController) -> SignalProducer<Action, NoError> {
        return SignalProducer { sink, disposable in
            let alert = UIAlertController()
            
            
            
            actions.forEach { action in
                alert.addAction(UIAlertAction(title: action.label, style: .default) { _ in
                    sink.send(value: action)
                    sink.sendCompleted()
                })
            }
            
            presenter.present(alert, animated: true)
            
            disposable.observeEnded {
                presenter.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
}
