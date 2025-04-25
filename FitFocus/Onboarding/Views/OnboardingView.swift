//
//  OnboardingView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 25/04/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State var showWalkThroughScreens : Bool = false
    var body: some View {
        ZStack{
            Color("BG")
                .ignoresSafeArea()
            
            OnboardingScreen()
                .animation(.interactiveSpring(response: 1.1, dampingFraction: 0.85, blendDuration: 0.85), value: showWalkThroughScreens)
        }

    }
    
    @ViewBuilder
    func OnboardingScreen() -> some View {
        GeometryReader{
            let size  = $0.size
            
            VStack(spacing: 10){
                Image("Intro")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height / 2, alignment: .center)
                
                Text("Focus more")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 55)
                
                Text(dummyText)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text("Let's Begin")
                    .font(.title3)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .foregroundColor(.white)
                    .background{
                        Capsule()
                            .fill(Color(.purple))
                    }
                    .onTapGesture {
                        showWalkThroughScreens.toggle()
                    }
                    .padding(.top, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
//            move up when clicked
            .offset(y: showWalkThroughScreens ? -size.height : 0)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingView()
}
