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
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack{
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
           
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
