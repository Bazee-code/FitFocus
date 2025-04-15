//
//  HomeViewModel.swift
//  FitFocus
//
//  Created by Eugene Obazee on 15/04/2025.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    let healthManager = HealthManager.shared
    
    @Published var calories: Int  = 123
    @Published var active:Int = 50
    @Published var stand:Int = 12
    
    var mockActivities = [
        Activity(id : 0, title : "Today steps", subtitle: "Goal 6,000", image : "figure.walk", tintColor: .green, amount : "32000"),
        Activity(id : 1, title : "Today steps", subtitle: "Goal 10,000", image : "figure.walk", tintColor: .blue, amount : "200"),
        Activity(id : 2, title : "Today steps", subtitle: "Goal 15,000", image : "figure.walk", tintColor: .red, amount : "550"),
        Activity(id : 3, title : "Today steps", subtitle: "Goal 20,000", image : "figure.run", tintColor: .yellow, amount : "11")
    ]
    
    var mockRecents = [
        RecentWorkouts(id : 0, image: "figure.run", title:  "Running",subtitle: "45 mins", calories: "50kcal", tintColor: .green),
        RecentWorkouts(id : 1, image: "figure.walk", title:  "Strength training",subtitle: "2 hrs", calories: "50kcal", tintColor: .blue),
        RecentWorkouts(id : 2, image: "figure.walk", title:  "Walking",subtitle: "30 mins", calories: "50kcal", tintColor: .red),
        RecentWorkouts(id : 3, image: "figure.walk", title:  "Swimming",subtitle: "45 mins", calories: "50kcal", tintColor: .yellow)
    ]
    
    init(){
        Task {
            do {
                try await healthManager.requestHealthKitSuccess()
                healthManager.fetchTodayCaloriesBurned {
                    result in
                    switch result {
                    case .success(let success):
                        print(success)
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
                
                healthManager.fetchTodayStandHours {
                    result in
                    switch result {
                    case .success(let success):
                        print(success)
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchTodayStandHours(){
        healthManager.fetchTodayStandHours {
            result in
            switch result {
            case .success(let hours):
                DispatchQueue.main.async {
                    self.stand = hours
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
