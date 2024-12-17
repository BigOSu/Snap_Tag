//
//  CameraPreview.swift
//  SnapTag
//
//  Created by Suraj Joshi on 28/09/24.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewControllerRepresentable {
    var session: AVCaptureSession?
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        previewLayer.frame = controller.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        controller.view.layer.addSublayer(previewLayer)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let layer = uiViewController.view.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            layer.session = session
        }
    }
}

struct CameraPreview_Previews: PreviewProvider {
    static var previews: some View {
        CameraPreview(session: AVCaptureSession())
            .frame(width: 300, height: 400) // Example dimensions for preview
    }
}


