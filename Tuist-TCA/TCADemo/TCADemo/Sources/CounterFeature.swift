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
        var isTimerRunning = false
    }
    
    // MARK: - Action
    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case toggleTimerButtonTapped
        case timerTick
    }
    
    enum CancelID { case timer }
    
    // MARK: - Reducer Body
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                return incrementButtonTapped(&state)
                
            case .decrementButtonTapped:
                return decrementButtonTapped(&state)
                
            case .factButtonTapped:
                return factButtonTapped(&state)
                
            case let .factResponse(fact):
                return factResponse(&state, fact)
                
            case .timerTick:
                return timerTick(&state)
                
            case .toggleTimerButtonTapped:
                return toggleTimerButtonTapped(&state)
                
            }
        }
    }
    
    // MARK: - Reducer Function
    private func incrementButtonTapped(_ state: inout CounterFeature.State) -> Effect<CounterFeature.Action> {
        state.count += 1
        state.fact = nil
        return .none
    }
    
    private func decrementButtonTapped(_ state: inout CounterFeature.State) -> Effect<CounterFeature.Action> {
        state.count -= 1
        state.fact = nil
        return .none
    }
    
    private func factButtonTapped(_ state: inout CounterFeature.State) -> Effect<CounterFeature.Action> {
        state.fact = nil
        state.isLoading = true
        return .run { [count = state.count] send in
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "http://numbersapi.com/\(count)")!)
            let fact = String(decoding: data, as: UTF8.self)
            await send(.factResponse(fact))
        }
    }
    
    private func factResponse(_ state: inout CounterFeature.State, _ fact: String) -> Effect<CounterFeature.Action> {
        state.fact = fact
        state.isLoading = false
        return .none
    }
    
    private func timerTick(_ state: inout CounterFeature.State) -> Effect<CounterFeature.Action> {
        state.count += 1
        state.fact = nil
        return .none
    }
    
    private func toggleTimerButtonTapped(_ state: inout CounterFeature.State) -> Effect<CounterFeature.Action> {
        state.isTimerRunning.toggle()
        if state.isTimerRunning {
            return .run { [isRunning = state.isTimerRunning] send in
                while true {
                    try await Task.sleep(for: .seconds(1))
                    await send(.timerTick)
                    if !isRunning {
                        break
                    }
                }
            }
            .cancellable(id: CancelID.timer)
        } else {
            return .cancel(id: CancelID.timer)
        }
    }
}
