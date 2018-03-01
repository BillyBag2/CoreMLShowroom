//
//  RN1015k500ViewController.swift
//  Core ML Showroom
//
//  Created by Raphael on 2/25/18.
//  Copyright © 2018 ghearly. All rights reserved.
//

import UIKit
import AVKit
import Vision
import MapKit

class RN1015k500ViewController: ModelViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    let captureSession = AVCaptureSession()

    let resultVisualEffectView : UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .dark)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let resultView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let placeContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let placeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.regular)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mapResult : MKMapView = {
        let map = MKMapView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        map.translatesAutoresizingMaskIntoConstraints = false
        map.mapType = .standard
        return map
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "RN1015k500"
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
        captureSession.addOutput(dataOutput)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        guard let model = try? VNCoreMLModel(for: RN1015k500().model) else {return}
        let request = VNCoreMLRequest(model: model) { (finishedRequest, err) in
            if let err = err {
                print(err)
            }
            
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            
            guard let firstResult = results.first else {return}
            DispatchQueue.main.async {
                let stringcoordinates = firstResult.identifier.components(separatedBy: "\t")
                let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(stringcoordinates[1])!, longitude: CLLocationDegrees(stringcoordinates[2])!)
                let span = MKCoordinateSpan(latitudeDelta: 0.0043, longitudeDelta: 0.0034)
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(stringcoordinates[1])!, longitude: CLLocationDegrees(stringcoordinates[2])!)
                self.mapResult.addAnnotation(annotation)
                self.mapResult.region = MKCoordinateRegion(center: coordinates, span: span)
                self.placeLabel.text = "LAT: \(stringcoordinates[1])\nLON:\(stringcoordinates[2])"
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func setupView(){
        view.addSubview(resultVisualEffectView)
        resultVisualEffectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        resultVisualEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultVisualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        resultVisualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        resultVisualEffectView.contentView.addSubview(resultView)
        resultView.topAnchor.constraint(equalTo: resultVisualEffectView.contentView.topAnchor, constant: 10).isActive = true
        resultView.leadingAnchor.constraint(equalTo: resultVisualEffectView.contentView.leadingAnchor, constant: 10).isActive = true
        resultView.trailingAnchor.constraint(equalTo: resultVisualEffectView.contentView.trailingAnchor, constant: -10).isActive = true
        
        resultView.addSubview(mapResult)
        mapResult.topAnchor.constraint(equalTo: resultView.topAnchor).isActive = true
        mapResult.leadingAnchor.constraint(equalTo: resultView.leadingAnchor).isActive = true
        mapResult.trailingAnchor.constraint(equalTo: resultView.trailingAnchor).isActive = true
        mapResult.bottomAnchor.constraint(equalTo: resultView.bottomAnchor).isActive = true
        mapResult.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        resultVisualEffectView.contentView.addSubview(placeContainerView)
        placeContainerView.topAnchor.constraint(equalTo: resultView.bottomAnchor, constant: 10).isActive = true
        placeContainerView.leadingAnchor.constraint(equalTo: resultVisualEffectView.contentView.leadingAnchor, constant: 10).isActive = true
        placeContainerView.trailingAnchor.constraint(equalTo: resultVisualEffectView.contentView.trailingAnchor, constant: -10).isActive = true
        placeContainerView.bottomAnchor.constraint(equalTo: resultVisualEffectView.contentView.bottomAnchor, constant: -10).isActive = true
        
        placeContainerView.addSubview(placeLabel)
        placeLabel.topAnchor.constraint(equalTo: placeContainerView.topAnchor, constant: 6).isActive = true
        placeLabel.bottomAnchor.constraint(equalTo: placeContainerView.bottomAnchor, constant: -6).isActive = true
        placeLabel.leadingAnchor.constraint(equalTo: placeContainerView.leadingAnchor, constant: 6).isActive = true
        placeLabel.trailingAnchor.constraint(equalTo: placeContainerView.trailingAnchor, constant: -6).isActive = true
        
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
