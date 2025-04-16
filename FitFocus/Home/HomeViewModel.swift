//
//  HomeViewModel.swift
//  FitFocus
//
//  Created by Eugene Obazee on 15/04/2025.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    let healthManager = HealthManager.shared
    
    @Published var calories: Int  = 0
    @Published var exercise: Int = 0
    @Published var stand: Int = 0
    @Published var steps: Int = 0
    
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
                try await healthManager.requestHealthKitAccess()
                    fetchTodaySteps()
                    fetchTodayCalories()
                    fetchTodayExerciseTime()
                    fetchTodayStandHours()
                    print("success")
                }
                catch {
                    print(error.localizedDescription)
                }
        }
    }
    
    func fetchTodaySteps(){
        healthManager.fetchTodaySteps {
            result in
            switch result {
            case .success(let steps):
                DispatchQueue.main.async {
                    self.steps = Int(steps)
                }
            case .failure :
                print("error fetching steps")
//                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchTodayCalories(){
        healthManager.fetchTodayCaloriesBurned {
            result in
            switch result {
            case .success(let calories):
                DispatchQueue.main.async {
                    self.calories = Int(calories)
                }
            case .failure:
                print("error fetching calories")
//                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchTodayExerciseTime(){
        healthManager.fetchTodayExerciseTime {
            result in
            switch result {
            case .success(let exercise):
                DispatchQueue.main.async {
                    self.exercise = Int(exercise)
                }
            case .failure:
                print("error fetching exercise time")
//                print(failure.localizedDescription)
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
            case .failure:
                print("error fetching stand hours")
//                print(failure.localizedDescription)
            }
        }
    }
}
