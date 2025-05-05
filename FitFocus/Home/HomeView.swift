//
//  HomeView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 14/04/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    Text("Welcome")
                        .font(.largeTitle)
                        .padding()
                }
                
                HStack{
                    Spacer()
                    VStack{
                        VStack(alignment: .leading, spacing: 8){
                            Text("Calories")
                                .font(.callout)
                                .bold()
                                .foregroundColor(.red)
                            Text("345 kcal")
                                .bold()
                        }
                        
                        .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 8){
                            Text("Active")
                                .font(.callout)
                                .bold()
                                .foregroundColor(.green)
                            Text("345 kcal")
                                .bold()
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 8){
                            Text("Stand")
                                .font(.callout)
                                .bold()
                                .foregroundColor(.red)
                            Text("8 hours")
                                .bold()
                        }
                    }
                    Spacer()
                    
                    ZStack{
                        ProgressCircleView(progress: $viewModel.calories, goal : 600, color: .red)
                        ProgressCircleView(progress: $viewModel.exercise, goal : 60, color: .green)
                            .padding(.all, 20)
                        ProgressCircleView(progress: $viewModel.stand, goal : 12, color: .blue)
                            .padding(.all, 40)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
                
                HStack{
                    Text("Fitness Activity")
                        .font(.title2)
                    
                    Spacer()
                    
                    Button{
                        print("show more")
                    }
                label: {
                    Text("Show more")
                        .padding(.all, 12)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(20)
                }
                }
                .padding(.horizontal)
                
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20),count: 2)){
                    ForEach(viewModel.mockActivities, id: \.id) { activity in
                        ActivityCardView(activity : activity)
                    }
                }
                .padding(.horizontal)
                
                HStack{
                    Text("Recent Workouts")
                        .font(.title2)
                    
                    Spacer();
                    NavigationLink{
                        EmptyView()
                    }
                label: {
                    Text("Show more")
                        .padding(.all, 12)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(20)
                }
                }
                .padding()
                
//                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count:1 )){
//                    ForEach(viewModel.mockRecents, id: \.id) { recentWorkout in
//                        RecentWorkoutsView(recentWorkout: recentWorkout)
//                    }
//                }
                
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
