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
            
            NavBar()
        }
        .animation(.interactiveSpring(response: 1.1, dampingFraction: 0.85, blendDuration: 0.85), value: showWalkThroughScreens)

    }
    
    @ViewBuilder
    func NavBar() -> some View {
        HStack{
            Button{
                showWalkThroughScreens.toggle()
            }
            label : {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)
            }
            
            Spacer()
            
            Button("Skip"){
                
            }
            .font(.title3)
            .foregroundColor(.purple)
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
        .frame(maxHeight: .infinity, alignment: .top)
        .offset(y: showWalkThroughScreens ? 0 : -120)
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
