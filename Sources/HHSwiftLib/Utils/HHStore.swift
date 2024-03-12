//
//  HHStore.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//

import Foundation
public protocol ActionType {}
public protocol StateType {}
public protocol CommandType {}

public class HHStore<A: ActionType, S: StateType, C: CommandType> {
    public let reducer: (_ state: S, _ action: A) -> (S, C?)
    public var subscriber: ((_ state: S, _ previousState: S, _ command: C?) -> Void)?
    public var state: S
    
    public init(reducer: @escaping (S, A) -> (S, C?), initialState: S) {
        self.reducer = reducer
        self.state = initialState
    }
    
    public func subscribe(_ handler: @escaping (S, S, C?) -> Void) {
        self.subscriber = handler
    }
    
    public func unsubscribe() {
        self.subscriber = nil
    }
    
    public func dispatch(_ action: A) {
        let previousState = state
        let (nextState, command) = reducer(state, action)
        state = nextState
        subscriber?(state, previousState, command)
    }
}
