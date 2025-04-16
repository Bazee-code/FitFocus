//
//  HealthManager.swift
//  FitFocus
//
//  Created by Eugene Obazee on 15/04/2025.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        let calendar = Calendar.current
        
        return calendar.startOfDay(for: Date())
    }
}

class HealthManager {
    
    static let shared = HealthManager()
    
    let healthStore = HKHealthStore()
    
    private init(){
        
        Task {
            do{
                try await requestHealthKitAccess()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func requestHealthKitAccess() async throws {
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps = HKQuantityType(.stepCount)
        
        let healthTypes : Set = [calories, exercise, stand, steps]
        
        try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
    }
    
    func fetchTodaySteps(){
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results,
            error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                print("Error fetching today step data")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            print(stepCount)
        }
        healthStore.execute(query)
    }
    
    func fetchTodayCaloriesBurned(completion: @escaping(Result<Double, Error>) -> Void){
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, results,
            error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(NSError()))
                return
            }
            
            let calorieCount = quantity.doubleValue(for: .kilocalorie())
            completion(.success(calorieCount))
        }
        healthStore.execute(query)
    }
    func fetchTodayExerciseTime(completion: @escaping(Result<Double, Error>) -> Void){
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results,
            error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(NSError()))
                return
            }
            
            let exerciseTime = quantity.doubleValue(for: .minute())
            completion(.success(exerciseTime))
        }
        healthStore.execute(query)
    }
    
    func fetchTodayStandHours(completion: @escaping(Result<Int, Error>) -> Void){
        let standTime = HKCategoryType(.appleStandHour)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: standTime, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results,
            error in
            guard let samples = results as? [HKCategorySample], error == nil else {
                completion(.failure(NSError()))
                return
            }
            
            
            let standCount = samples.filter({$0.value == 0}).count
            
            completion(.success(standCount))
        }
        healthStore.execute(query)
    }
    
}
