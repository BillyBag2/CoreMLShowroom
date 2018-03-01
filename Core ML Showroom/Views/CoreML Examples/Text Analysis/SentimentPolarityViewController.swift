//
//  SentimentPolarityViewController.swift
//  Core ML Showroom
//
//  Created by Raphael on 2/25/18.
//  Copyright © 2018 ghearly. All rights reserved.
//

import UIKit

class SentimentPolarityViewController: ModelViewController, UITextViewDelegate {
    
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
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "SentimentPolarity"
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
    
    let inputTextView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        textView.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.white.cgColor
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // Setup View Blur BG
        view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
        
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
        
        view.addSubview(inputTextView)
        inputTextView.delegate = self
        inputTextView.topAnchor.constraint(equalTo: stackTop.bottomAnchor, constant: 20).isActive = true
        inputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        inputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        inputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func infoTapped() {
        let modelInfoVC = ModelInfoViewController()
        modelInfoVC.modalPresentationStyle = .overCurrentContext
        modelInfoVC.model = model
        present(modelInfoVC, animated: true, completion: nil)
    }
}
