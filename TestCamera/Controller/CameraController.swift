//
//  CameraController.swift
//  TestCamera
//
//  Created by Андрей Важенов on 20.06.2022.
//

import Foundation


import UIKit
import AVFoundation
import Photos

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var captureSession = AVCaptureSession()
    let cameraOutput = AVCapturePhotoOutput()
    var gestureRecognizer = UIPinchGestureRecognizer()
    var prevZoomFactor: CGFloat = 1
    var captureDevice: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    enum CameraDirection {
        case front
        case back
    }
    
    var currentDirection: CameraDirection = .back
    var deviceOrientation: UIImage.Orientation!
    var flashEffectView = UIView()
    var imageView: UIImageView!

    var flashMode: AVCaptureDevice.FlashMode! = .off
    let buttonFlashSwitch: UIButton = UIButton(type: UIButton.ButtonType.custom)
    let buttonCameraSwitch: UIButton = UIButton(type: UIButton.ButtonType.custom)
    let buttonImportPicture: UIButton = UIButton(type: UIButton.ButtonType.custom)
    let buttonGridSwitch: UIButton = UIButton(type: UIButton.ButtonType.custom)
    var buttonCameraShot = UIButton(type: .custom)
    var buttonCameraShotTwo = UIButton(type: .custom)
    var buttonTimer = UIButton(type: .custom)
    var butttonRatio = UIButton(type: .custom)
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 75)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.captureSession.sessionPreset = .photo
        captureDevice = getDevice(position: .back)
        deviceOrientation = .right
        self.navigationController?.navigationBar.isHidden = true
        imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.size.width, height: view.frame.size.height)))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(imageView)
        
        buttonFlashSwitch.setImage(UIImage(named: "Flash"), for: UIControl.State.normal)
        buttonFlashSwitch.addTarget(self, action: #selector(switchFlash), for: UIControl.Event.touchUpInside)
        buttonFlashSwitch.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        buttonFlashSwitch.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.addSubview(buttonFlashSwitch)
    
        buttonImportPicture.addTarget(self, action: #selector(importPicture), for: UIControl.Event.touchUpInside)
        buttonImportPicture.imageView?.layer.cornerRadius = 10
        buttonImportPicture.contentMode = .scaleAspectFit
        buttonImportPicture.layer.masksToBounds = false
        buttonImportPicture.clipsToBounds = true
        buttonImportPicture.backgroundColor = #colorLiteral(red: 0.1079640165, green: 0.1179675236, blue: 0.1687111855, alpha: 1)
        view.addSubview(buttonImportPicture)
        
        
        buttonCameraSwitch.setImage(UIImage(named: "changeCamera"), for: UIControl.State.normal)
        buttonCameraSwitch.addTarget(self, action: #selector(switchCamera), for: UIControl.Event.touchUpInside)
        buttonCameraSwitch.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.addSubview(buttonCameraSwitch)
        
        
        buttonCameraShot.setBackgroundImage(UIImage(named: "shotButton"), for: UIControl.State.normal)
        buttonCameraShot.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        view.addSubview(buttonCameraShot)
        buttonCameraShotTwo.setBackgroundImage(UIImage(named: "shotButton"), for: UIControl.State.normal)
        buttonCameraShotTwo.addTarget(self, action: #selector(capturePhotoTimer), for: .touchUpInside)
        buttonCameraShotTwo.isHidden = true
        view.addSubview(buttonCameraShotTwo)
        
        
        flashEffectView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.size.width, height: view.frame.size.height)))
        flashEffectView.alpha = 0
        flashEffectView.backgroundColor = UIColor.white
        view.addSubview(flashEffectView)
        
        // Timer
        buttonTimer.addTarget(self, action: #selector(timerPhoto), for: .touchUpInside)
        buttonTimer.setImage(UIImage(named: "Timer"), for: UIControl.State.normal)
        buttonTimer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        view.addSubview(buttonTimer)
        
        // Ratio
        butttonRatio.addTarget(self, action: #selector(ratioPhoto), for: .touchUpInside)
        butttonRatio.setImage(UIImage(named: "Ratio4"), for: UIControl.State.normal)
        butttonRatio.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        view.addSubview(butttonRatio)
        
        numberLabel.isHidden = true
        view.addSubview(numberLabel)
        
        beginNewSession()
        setConsrtraints()
        gestureRecognizer = UIPinchGestureRecognizer(target: self, action:#selector(pinchRecognized))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCamera()
    }
    
    func setConsrtraints() {
        buttonCameraSwitch.translatesAutoresizingMaskIntoConstraints = false
        buttonImportPicture.translatesAutoresizingMaskIntoConstraints = false
        buttonCameraShot.translatesAutoresizingMaskIntoConstraints = false
        buttonCameraShotTwo.translatesAutoresizingMaskIntoConstraints = false
        buttonFlashSwitch.translatesAutoresizingMaskIntoConstraints = false

        buttonTimer.translatesAutoresizingMaskIntoConstraints = false
        butttonRatio.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonCameraSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonCameraSwitch.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            buttonImportPicture.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonImportPicture.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            buttonImportPicture.heightAnchor.constraint(equalToConstant: 50),
            buttonImportPicture.widthAnchor.constraint(equalToConstant: 50),
            
            buttonCameraShot.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            buttonCameraShot.heightAnchor.constraint(equalToConstant: 70),
            buttonCameraShot.widthAnchor.constraint(equalToConstant: 70),
            buttonCameraShot.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonCameraShotTwo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            buttonCameraShotTwo.heightAnchor.constraint(equalToConstant: 70),
            buttonCameraShotTwo.widthAnchor.constraint(equalToConstant: 70),
            buttonCameraShotTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            numberLabel.bottomAnchor.constraint(equalTo: buttonCameraSwitch.topAnchor, constant: -100),
            numberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            numberLabel.widthAnchor.constraint(equalToConstant: 70),
            numberLabel.heightAnchor.constraint(equalToConstant: 70),
            
            buttonFlashSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonFlashSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                        
            buttonTimer.centerYAnchor.constraint(equalTo: buttonFlashSwitch.centerYAnchor),
            buttonTimer.leadingAnchor.constraint(equalTo: buttonFlashSwitch.trailingAnchor, constant: 10),
            
            butttonRatio.centerYAnchor.constraint(equalTo: buttonFlashSwitch.centerYAnchor),
            butttonRatio.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            
        ])
    }
  
    @objc func capturePhotoTimer() {
        print("TapTwo")
        if buttonTimer.currentImage == UIImage(named:"Timer3S") {
            numberLabel.isHidden = false
            var startNumber = 3
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (time) in
                
                self.numberLabel.text = String(startNumber)
                startNumber -= 1
                
                UIView.animate(withDuration: 0.99, animations: {
                    self.numberLabel.alpha = 0
                }, completion: { (true) in
                    self.numberLabel.alpha = 1
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                timer.invalidate()
                self.numberLabel.isHidden = true
                self.capturePhoto()
            }
            
        } else if buttonTimer.currentImage == UIImage(named:"Timer10S") {
            numberLabel.isHidden = false
            var startNumber = 10
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (time) in
                self.numberLabel.text = String(startNumber)
                startNumber -= 1
                
                UIView.animate(withDuration: 0.99, animations: {
                    self.numberLabel.alpha = 0
                }, completion: { (true) in
                    self.numberLabel.alpha = 1
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
                timer.invalidate()
                self.numberLabel.isHidden = true
                self.capturePhoto()
            }
        }
    }
    
    
    @objc func timerPhoto() {
        if buttonTimer.currentImage == UIImage(named: "Timer") {
            buttonTimer.setImage(UIImage(named:"Timer3S"), for: .normal)
            buttonCameraShot.isHidden = true
            buttonCameraShotTwo.isHidden = false
            
        } else if buttonTimer.currentImage == UIImage(named: "Timer3S") {
            buttonTimer.setImage(UIImage(named:"Timer10S"), for: .normal)
            buttonCameraShot.isHidden = true
            buttonCameraShotTwo.isHidden = false
            
        } else {
            buttonTimer.setImage( UIImage(named:"Timer"), for: .normal)
            buttonCameraShot.isHidden = false
            buttonCameraShotTwo.isHidden = true
            numberLabel.isHidden = true
        }
    }
    
    @objc func setLibraryPic() {
        let manager = PHImageManager.default()
        let imageAsset = PHAsset.fetchAssets(with: .image, options: nil)
        var lastImg: UIImage?
        
        if imageAsset.count > 0 {
            manager.requestImage(for: imageAsset[imageAsset.count - 1], targetSize: CGSize(width: 20, height: 20), contentMode: .aspectFill, options: nil) { image, info in
                lastImg = image?.fixOrientation()
            }
            buttonImportPicture.setImage(lastImg, for: UIControl.State.normal)
            
        } else {
            print("No image assets found.")
            buttonImportPicture.setImage(UIImage(named: "photo.fill"), for: UIControl.State.normal)
        }
    }
    
    @objc func ratioPhoto() {
        if butttonRatio.currentImage == UIImage(named: "Ratio4") {
            butttonRatio.setImage(UIImage(named:"Ratio"), for: .normal)
            
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer.bounds.size.width = view.bounds.size.width
            previewLayer.bounds.size.height = view.bounds.size.width
            previewLayer.zPosition = -1
            
        } else if butttonRatio.currentImage == UIImage(named: "Ratio") {
            print("Tap Ratio")
            butttonRatio.setImage(UIImage(named:"Ratio16"), for: .normal)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer.frame = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.size.width, height: view.bounds.size.height)
            previewLayer.zPosition = -1
        } else {
            butttonRatio.setImage( UIImage(named:"Ratio4"), for: .normal)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            previewLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height * 0.87)
            
            previewLayer.zPosition = -1
        }
    }
    
    func beginNewSession() {
        if let input = try? AVCaptureDeviceInput(device: captureDevice!) {
            if captureSession.canAddInput(input) {
                self.captureSession.addInput(input)
                self.captureSession.addOutput(cameraOutput)
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                self.view.layer.addSublayer(previewLayer)
                previewLayer.frame.size.width = self.view.layer.frame.size.width // отвечает за размер видоискателя камеры
                previewLayer.frame.size.height = self.view.layer.frame.size.height * 0.87
                previewLayer.zPosition = -1
                captureSession.startRunning()
                setLibraryPic()
            }
        } else {
            print("captureDevice error!")
        }
    }
    
    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        
        let deviceConverted = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position)
        
        return deviceConverted
    }
    
    @objc func switchFlash() {
        switch flashMode {
        case .on:
            flashMode = .off
            buttonFlashSwitch.setImage(UIImage(named: "Flash"), for: UIControl.State.normal)
            print("Flash")
        case .off:
            flashMode = .auto
            buttonFlashSwitch.setImage(UIImage(named: "FlashA"), for: UIControl.State.normal)
            print("flash auto")
        case .auto:
            flashMode = .on
            buttonFlashSwitch.setImage(UIImage(named: "FlashActiv"), for: UIControl.State.normal)
            print("flash on")
        default:
            flashMode = .off
            buttonFlashSwitch.setImage(UIImage(named: "Flash"), for: UIControl.State.normal)
        }
    }
    

    
    @objc func switchCamera() {
        captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
                captureSession.removeOutput(cameraOutput)
            }
        }
        if (currentDirection == .front) {
            captureDevice = getDevice(position: .back)
            currentDirection = .back
        } else {
            captureDevice = getDevice(position: .front)
            currentDirection = .front
        }
        beginNewSession()
    }
    
    @objc func capturePhoto() {
        print("PhotoTap")
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        settings.flashMode = flashMode
        settings.isHighResolutionPhotoEnabled = false
        
        self.cameraOutput.isHighResolutionCaptureEnabled = true
        self.cameraOutput.capturePhoto(with: settings, delegate: self)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: { () -> Void in
            self.flashEffectView.alpha = 1
        }, completion: {(finished: Bool) in
            self.flashEffectView.alpha = 0
        })
        
    }
    
    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: beginNewSession() // Do your stuff here i.e. callCameraMethod()
        case .denied: alertToEncourageCameraAccessInitially()
        case .notDetermined: alertPromptToAllowCameraAccessViaSetting()
        default: alertToEncourageCameraAccessInitially()
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { alert in
            if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                    DispatchQueue.main.async() {
                        self.checkCamera() } }
            }
        }
        )
        present(alert, animated: true, completion: nil)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
        }
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData)?.withRenderingMode(.alwaysOriginal) else { return }
        
        let imageWithRightOrientation: UIImage = UIImage(cgImage: image.cgImage!, scale: 1, orientation: deviceOrientation)
        
        let dest = EffectsVC()
        dest.imagePhoto = imageWithRightOrientation
       
        self.navigationController?.pushViewController(dest, animated: false)
        
        print("image captured.")
    }
    

    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        print("Tap image")
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        imageView.alpha = 0
        dismiss(animated: true, completion: nil)
        imageView.backgroundColor = .black
        imageView.image = image.fixOrientation()
        let dest = EffectsVC()
        dest.imagePhoto = imageView.image
        self.navigationController?.pushViewController(dest, animated: false)
        
    }

    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer) {
        let device = captureDevice!
        let vZoomFactor = pinch.scale * prevZoomFactor
        
        if pinch.state == .ended {
            
            if vZoomFactor >= 1.0 {
                prevZoomFactor = vZoomFactor
            } else {
                prevZoomFactor = 1.0
            }
            
            if vZoomFactor > 16.0 {
                prevZoomFactor = 16.0
            }
        }
        
        do {
            try device.lockForConfiguration()
            defer {device.unlockForConfiguration()}
            
            if (vZoomFactor >= 1.0 && vZoomFactor <= device.activeFormat.videoMaxZoomFactor){
                device.videoZoomFactor = vZoomFactor
            } else {
                NSLog("Unable to set videoZoom: (max %f, asked %f)", device.activeFormat.videoMaxZoomFactor, vZoomFactor);
            }
            
            if vZoomFactor > 16.0 {
                NSLog("Unable to set videoZoom: (max %f, asked %f)", device.activeFormat.videoMaxZoomFactor, vZoomFactor);
            }
            
        } catch let error {
            NSLog("Unable to set videoZoom: %@", error.localizedDescription);
        }
    }
}
