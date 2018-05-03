//
//  Bind.swift
//  Shopper
//
//  Created by Kaushik on 4/27/18.
//  Copyright © 2018 Kaushik. All rights reserved.
//

class Bind<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
