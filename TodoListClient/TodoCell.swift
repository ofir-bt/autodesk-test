//
//  TodoCell.swift
//  TodoListClient
//
//  Created by Oren Idan on 09/07/2017.
//  Copyright © 2017 Oren Idan. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

protocol TodoCellDelegate {
    func actionTapped(todoVM: TodoItemViewModel?)
}

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var titleDisposable: Disposable?
    var completedDisposable: Disposable?
    
    var todoVM: TodoItemViewModel! {
        didSet {
            
            titleDisposable = (titleLabel.reactive.text <~ todoVM.title.producer)
            
            completedDisposable = todoVM.completed.producer.startWithResult { [weak self](result) in
                guard let strongSelf = self else { return }
                if let completed = result.value   {
                    
                    if completed    {
                        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: strongSelf.todoVM.title.value)
                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                        strongSelf.titleLabel?.attributedText = attributeString
                        strongSelf.actionButton?.setTitle("Uncomplete", for: .normal)
                    }
                    else    {
                        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: strongSelf.todoVM.title.value)
                        strongSelf.actionButton?.setTitle("Complete", for: .normal)
                        attributeString.removeAttribute(NSAttributedStringKey.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
                        strongSelf.titleLabel?.attributedText = attributeString
                    }
                }
            }
        }
    }
    
    
    var delegate: TodoCellDelegate?
    
    
    func updateCell(todoVM: TodoItemViewModel, delegate: TodoCellDelegate?) {
        self.todoVM = todoVM
        self.delegate = delegate
    }
    
    @IBAction func action(_ sender: UIButton) {
        delegate?.actionTapped(todoVM: todoVM)
    }
    
    override func prepareForReuse() {
        titleDisposable?.dispose()
        completedDisposable?.dispose()
    }
}
