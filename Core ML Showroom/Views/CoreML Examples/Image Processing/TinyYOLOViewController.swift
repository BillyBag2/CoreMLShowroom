//
//  TinyYOLOViewController.swift
//  Core ML Showroom
//
//  Created by Raphael on 2/25/18.
//  Copyright © 2018 ghearly. All rights reserved.
//

import UIKit
import AVKit
import Vision
import Accelerate

class TinyYOLOViewController: ModelViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let captureSession = AVCaptureSession()

    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "TinyYOLO"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleVisualEffectView : UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .dark)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let closeButtonBlurEffect : UIVisualEffectView = {
        let visualEffect = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        visualEffect.effect = UIBlurEffect(style: .dark)
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.layer.cornerRadius = 14
        visualEffect.layer.masksToBounds = true
        return visualEffect
    }()
    
    let closeButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "closebt"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let infoButtonBlurEffect : UIVisualEffectView = {
        let visualEffect = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        visualEffect.effect = UIBlurEffect(style: .dark)
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.layer.cornerRadius = 14
        visualEffect.layer.masksToBounds = true
        return visualEffect
    }()
    
    let infoButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "info"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(infoTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupView()
        
    }
    
    func setupCaptureSession() {
        // Setting up Capture Session, Adding a preview layer to our view and outputing data
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession.addInput(input)
        captureSession.startRunning()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        dataOutput.videoSettings = [ kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA) ]
        captureSession.addOutput(dataOutput)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
    func setupView(){
        let stackTop = UIStackView(arrangedSubviews: [closeButtonBlurEffect ,titleVisualEffectView, infoButtonBlurEffect])
        stackTop.distribution = .fillProportionally
        stackTop.spacing = 6
        stackTop.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackTop)
        stackTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackTop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackTop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stackTop.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        titleVisualEffectView.contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: titleVisualEffectView.contentView.topAnchor, constant: 6).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: titleVisualEffectView.contentView.leadingAnchor, constant: 6).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: titleVisualEffectView.contentView.trailingAnchor, constant: -6).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: titleVisualEffectView.contentView.bottomAnchor, constant: -6).isActive = true
        
        closeButtonBlurEffect.contentView.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: closeButtonBlurEffect.contentView.topAnchor, constant: 6).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: closeButtonBlurEffect.contentView.leadingAnchor, constant: 6).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: closeButtonBlurEffect.contentView.trailingAnchor, constant: -6).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: closeButtonBlurEffect.contentView.bottomAnchor, constant: -6).isActive = true
        
        infoButtonBlurEffect.contentView.addSubview(infoButton)
        infoButton.topAnchor.constraint(equalTo: infoButtonBlurEffect.contentView.topAnchor, constant: 6).isActive = true
        infoButton.leadingAnchor.constraint(equalTo: infoButtonBlurEffect.contentView.leadingAnchor, constant: 6).isActive = true
        infoButton.trailingAnchor.constraint(equalTo: infoButtonBlurEffect.contentView.trailingAnchor, constant: -6).isActive = true
        infoButton.bottomAnchor.constraint(equalTo: infoButtonBlurEffect.contentView.bottomAnchor, constant: -6).isActive = true
    }
    
    @objc func closeTapped() {
        captureSession.stopRunning()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func infoTapped() {
        let modelInfoVC = ModelInfoViewController()
        modelInfoVC.modalPresentationStyle = .overCurrentContext
        modelInfoVC.model = model
        present(modelInfoVC, animated: true, completion: nil)
    }

}
