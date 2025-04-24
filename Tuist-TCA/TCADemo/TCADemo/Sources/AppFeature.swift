//
//  AppFeature.swift
//  TCADemo
//
//  Created by 김동영 on 4/24/25.
//

import ComposableArchitecture

@Reducer
struct AppFeature {
    struct State: Equatable {
        var aModuleState = CounterFeature.State()
        var bModuleState = CounterFeature.State()
    }
    enum Action {
        case aModuleAction(CounterFeature.Action)
        case bModuleAction(CounterFeature.Action)
    }
    var body: some ReducerOf<Self> {
        Scope(state: \.aModuleState, action: \.aModuleAction) {
            CounterFeature()
        }
        Scope(state: \.bModuleState, action: \.bModuleAction) {
            CounterFeature()
        }
        Reduce { state, action in
            // Core logic of the app feature
            return .none
        }
    }
}
