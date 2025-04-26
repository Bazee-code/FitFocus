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

let onboardingTitle = "Fitness meets Productivity"
let onboardingDescription = "What if i told you there's a way to tie your fitness goals to your social media habits? 😱"
