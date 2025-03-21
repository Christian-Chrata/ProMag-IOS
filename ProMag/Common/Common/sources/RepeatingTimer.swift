//
//  RepeatingTImer.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import Foundation

public typealias TimerModelHandler = (_ second: Int, _ isCompleted: Bool) -> Void

public class TimerModel {
    public static let shared: TimerModel = {
        let model = TimerModel()
        return model
    }()
    
    private var counter = 0 {
        didSet {
            start = Date()
        }
    }
    private var start = Date()
    private var dispatchSourceTimer: DispatchSourceTimer?
    private var handlers: [String: TimerModelHandler] = [:]
    
    public var onProgress: Bool = false
    public var isCompleted: Bool = false
    
    private init() {}
    
    private func create() {
        dispatchSourceTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        dispatchSourceTimer?.schedule(deadline: .now() + 1, repeating: .seconds(1))
        dispatchSourceTimer?.setEventHandler(handler: { [weak self] in
            guard let `self` = self else { return }
            if Date().seconds(from: self.start) >= self.counter {
                self.isCompleted = true
                self.handlers.forEach { (handler) in
                    handler.value(0, true)
                }
                self.cancel()
            } else {
                self.isCompleted = false
                self.handlers.forEach { (handler) in
                    let second = self.counter - Date().seconds(from: self.start)
                    handler.value(second, false)
                }
            }
        })
    }
    
    public func start(with second: Int) {
        counter = second
        create()
        onProgress = true
        dispatchSourceTimer?.resume()
    }
    
    public func pause() {
        onProgress = false
        dispatchSourceTimer?.suspend()
    }
    
    public func cancel() {
        onProgress = false
        dispatchSourceTimer?.cancel()
        dispatchSourceTimer = nil
    }
    
    public func observe(key: String, completion: @escaping TimerModelHandler) {
        handlers[key] = completion
    }
    
    deinit {
        cancel()
    }
}
