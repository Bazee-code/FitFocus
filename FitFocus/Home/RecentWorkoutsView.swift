//
//  RecentWorkoutsView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 14/04/2025.
//

import SwiftUI

struct RecentWorkouts {
    let id : Int
    let image : String
    let title : String
    let subtitle : String
    let calories : String
}

struct RecentWorkoutsView: View {
    
    @State var recentWorkout : RecentWorkouts
    
    var body: some View {
        HStack{
                Image(systemName: recentWorkout.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.green)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 10){
                Text(recentWorkout.title)
                    .font(.title3)
                    .bold()
                    
                
                HStack{
                    Text(recentWorkout.subtitle)
                        .font(.title3)
                    
                    Spacer()
                    
                    Text(recentWorkout.calories)
                        .font(.title3)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct RecentWorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        RecentWorkoutsView(recentWorkout: RecentWorkouts(id : 0, image: "figure.walk", title:  "Running", subtitle: "45 mins", calories: "50kcal"))
    }
}
