//
//  SplashView.swift
//  SnapTag
//
//  Created by Suraj Joshi on 28/09/24.
//

// SplashView.swift
import SwiftUI

struct SplashView: View {
    @State private var animateText = false
    @State private var navigateToCamera = false
    
    var body: some View {
        ZStack {
            NavigationLink(destination: CameraView(), isActive: $navigateToCamera) {
                EmptyView()
            }
            .hidden()
            
            Color.black.edgesIgnoringSafeArea(.all)
            
            BouncingText(
                text: "SnapTag",
                style: .init(
                    font: Font.custom("HelveticaNeue-Bold", size: 50),
                    color: .white,
                    offsetYForBounce: -50,
                    dropSpeed: 0.3,
                    opacity: 0
                )
            )
            .onAppear {
                animateText = true
                // Navigate to CameraView after 2.5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    navigateToCamera = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

