//
//  ViewController.swift
//  TextRecognition
//
//  Created by Mohammad Sulthan on 01/10/21.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Starting..."
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Example2")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        recognizeText(image: imageView.image)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 20, y: view.safeAreaInsets.top, width: view.frame.size.width - 40, height:  view.frame.size.width - 40)
        label.frame = CGRect(x: 20, y: view.frame.size.width + view.safeAreaInsets.top, width: view.frame.size.width-40, height: 200)
    }
    
    func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            fatalError("Can't get CGImage")
        }
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest  { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                      return
                  }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
            DispatchQueue.main.async {
                self?.label.text = text
            }
        }
        
        // Process request
        do {
            try handler.perform([request])
        } catch {
            label.text = "\(error)"
        }
    }
}

