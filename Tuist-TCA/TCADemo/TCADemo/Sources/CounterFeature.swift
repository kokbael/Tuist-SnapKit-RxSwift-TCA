//
//  CounterFeature.swift
//  TCADemo
//
//  Created by 김동영 on 4/24/25.
//

import ComposableArchitecture

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
                return .none
            }
        }
    }
}
