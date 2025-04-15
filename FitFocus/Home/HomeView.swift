//
//  HomeView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 14/04/2025.
//

import SwiftUI

struct HomeView: View {
    @State var calories: Int  = 123
    @State var active:Int = 50
    @State var stand:Int = 12
    
    var mockActivities = [
        Activity(id : 0, title : "Today steps", subtitle: "Goal 6,000", image : "figure.walk", tintColor: .green, amount : "5000"),
        Activity(id : 1, title : "Today steps", subtitle: "Goal 10,000", image : "figure.walk", tintColor: .blue, amount : "5000"),
        Activity(id : 2, title : "Today steps", subtitle: "Goal 15,000", image : "figure.walk", tintColor: .red, amount : "5000"),
        Activity(id : 3, title : "Today steps", subtitle: "Goal 20,000", image : "figure.run", tintColor: .yellow, amount : "5000")
    ]
    
    var mockRecents = [
        RecentWorkouts(id : 0, image: "figure.run", title:  "Running",subtitle: "45 mins", calories: "50kcal"),
        RecentWorkouts(id : 1, image: "figure.walk", title:  "Strength training",subtitle: "2 hrs", calories: "50kcal"),
        RecentWorkouts(id : 2, image: "figure.walk", title:  "Walking",subtitle: "30 mins", calories: "50kcal"),
        RecentWorkouts(id : 3, image: "figure.walk", title:  "Swimming",subtitle: "45 mins", calories: "50kcal")
    ]
    
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
                        ProgressCircleView(progress: $calories, goal : 600, color: .red)
                        ProgressCircleView(progress: $active, goal : 60, color: .green)
                            .padding(.all, 20)
                        ProgressCircleView(progress: $stand, goal : 12, color: .blue)
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
                    ForEach(mockActivities, id: \.id) { activity in
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
                
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count:1 )){
                    ForEach(mockRecents, id: \.id) { recentWorkout in
                        RecentWorkoutsView(recentWorkout: recentWorkout)
                    }
                }
                
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
