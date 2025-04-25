//
//  Onboarding.swift
//  FitFocus
//
//  Created by Eugene Obazee on 25/04/2025.
//

import SwiftUI

struct Onboarding: Identifiable {
    var id: String = UUID().uuidString
    var imageName: String
    var title: String
}

var onboarding: [Onboarding] = [
    .init(imageName: "onboarding1", title: "FitFocus"),
    .init(imageName: "onboarding2", title: "Track your workouts"),
    .init(imageName: "onboarding3", title: "Set your goals"),
]

let dummyText = "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book"
