//
//  CameraView.swift
//  SnapTag
//
//  Created by Suraj Joshi on 28/09/24.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var showPreview = false

    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Button(action: {
                    viewModel.capturePhoto()
                    showPreview = true
                }) {
                    Text("Capture Photo")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
        .background(
            NavigationLink(
                destination: PreviewView(image: viewModel.capturedImage),
                isActive: $showPreview
            ) {
                EmptyView()
            }
            .hidden()
        )
    }
}


struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
            .environmentObject(CameraViewModel())
    }
}
