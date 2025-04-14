//
//  ActivityCardView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 14/04/2025.
//

import SwiftUI

struct Activity {
    let id : Int
    let title : String
    let subtitle : String
    let image : String
    let tintColor : Color
    let amount : String
}

struct ActivityCardView: View {
    @State var activity : Activity
    
    var body: some View {
        ZStack{
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack{
                HStack{
                    VStack(alignment: .leading, spacing: 8){
                        Text(activity.title)
                        Text(activity.subtitle)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundColor(activity.tintColor)
                }
                .padding()
                Text(activity.amount)
                    .font(.title)
                    .bold()
                    .padding()
            }
        }
    }
}

struct ActivityCardView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCardView(activity: Activity(id : 0, title : "Today steps", subtitle: "Goal 6,000", image : "figure.walk", tintColor: .green, amount : "5000"))
    }
}
