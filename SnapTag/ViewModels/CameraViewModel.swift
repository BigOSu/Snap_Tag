//
//  CameraViewModel.swift
//  SnapTag
//
//  Created by Suraj Joshi on 28/09/24.
//

import Foundation
import AVFoundation
import UIKit

class CameraViewModel: NSObject, ObservableObject {
    @Published var capturedImage: UIImage?
    var session: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?

    override init() {
        super.init()
        setupCamera()
    }

    private func setupCamera() {
        session = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Error setting up video input: \(error)")
            return
        }
        
        if session?.canAddInput(videoInput) == true {
            session?.addInput(videoInput)
        } else {
            print("Unable to add video input to session.")
            return
        }
        
        photoOutput = AVCapturePhotoOutput()
        if session?.canAddOutput(photoOutput!) == true {
            session?.addOutput(photoOutput!)
        } else {
            print("Unable to add photo output to session.")
            return
        }
    }

    func startSession() {
        guard let session = session, !session.isRunning else { return }
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }

    func stopSession() {
        guard let session = session, session.isRunning else { return }
        DispatchQueue.global(qos: .background).async {
            session.stopRunning()
        }
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        guard let imageData = photo.fileDataRepresentation() else { return }
        DispatchQueue.main.async {
            self.capturedImage = UIImage(data: imageData)
        }
    }
}
