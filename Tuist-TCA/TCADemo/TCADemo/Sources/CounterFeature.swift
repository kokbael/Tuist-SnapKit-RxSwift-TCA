//
//  CounterFeature.swift
//  TCADemo
//
//  Created by 김동영 on 4/24/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CounterFeature {
    // MARK: - State
    @ObservableState // SwiftUI 뷰에서 관찰 가능하도록 설정
    struct State: Equatable { // 테스트 용이성을 위해 Equatable 채택
        var count = 0
        var isLoading = false
        var fact: String?
    }
    
    // MARK: - Action
    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case factButtonTapped
        case factResponse(String)
    }
    
    // MARK: - Reducer Body
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [count = state.count] send in
                    let (data, _) = try await URLSession.shared
                        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    await send(.factResponse(fact))
                }
                
            case let .factResponse(fact):
              state.fact = fact
              state.isLoading = false
              return .none
            }
        }
    }
}
