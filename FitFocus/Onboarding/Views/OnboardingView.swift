//
//  OnboardingView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 25/04/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State var showWalkThroughScreens : Bool = false
    @State var currentIndex: Int = 0
    
    var body: some View {
        ZStack{
            Color("BG")
                .ignoresSafeArea()
            
            OnboardingScreen()
            
            WalkThroughScreens()
            
            NavBar()
        }
        .animation(.interactiveSpring(response: 1.1, dampingFraction: 0.85, blendDuration: 0.85), value: showWalkThroughScreens)

    }
    
    @ViewBuilder
    func WalkThroughScreens() -> some View {
        GeometryReader{
            let size = $0.size
            
            ZStack{
                ForEach(onboarding.indices, id: \.self){
                    index in ScreenView(size: size, index: index)
                }
                
                WelcomeView(size: size, index: onboarding.count)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom){
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(width: 55, height: 55)
                    .foregroundColor(.white)
                    .background{
                        RoundedRectangle(cornerRadius: 30, style: .circular)
                            .fill(.orange)
                    }
                    .onTapGesture {
                        currentIndex += 1
                    }
                    .offset(y : -90)
            }
            .offset(y: showWalkThroughScreens ? 0 : size.height)
        }
    }
    
    @ViewBuilder
    func WelcomeView(size: CGSize, index: Int) -> some View {
        
        VStack(spacing: 10){
            Image("Welcome")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250, alignment: .top)
                .padding(.horizontal, 20)
                .offset(x : -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0 : 0.2).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Text("Welcome")
                .font(.title)
                .fontWeight(.bold)
                .offset(x : -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Text("Get more fit and increase your productivity")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .offset(x : -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
        }
    }
    
    @ViewBuilder
    func ScreenView(size: CGSize, index: Int) -> some View {
        let intro = onboarding[index]
        
        VStack(spacing: 10){
            Text(intro.title)
                .font(.title)
                .fontWeight(.bold)
                .offset(x : -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Text(onboardingDescription)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .offset(x : -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Image(intro.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250, alignment: .top)
                .padding(.horizontal, 20)
                .offset(x : -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0 : 0.2).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
        }
    }
    
    @ViewBuilder
    func NavBar() -> some View {
        HStack{
            Button{
                if currentIndex > 0 {
                    currentIndex -= 1
                } else {
                    showWalkThroughScreens.toggle()
                }
            }
            label : {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
            }
            
            Spacer()
            
            Button("Skip"){
                
            }
            .font(.title3)
            .foregroundColor(.orange)
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
                
                Text(onboardingTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 55)
                
                Text(onboardingDescription)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text("Tell me more")
                    .font(.title3)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .foregroundColor(.white)
                    .background{
                        Capsule()
                            .fill(Color(.orange))
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
