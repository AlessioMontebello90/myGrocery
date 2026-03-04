import SwiftUI
import AVFoundation

struct BarcodeScannerView: UIViewControllerRepresentable {
    
    var completion: (String) -> Void
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let controller = ScannerViewController()
        controller.completion = completion
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
}

// MARK: - UIKit Scanner Controller

final class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var completion: ((String) -> Void)?
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        #if targetEnvironment(simulator)
        showSimulatorAlert()
        #else
        checkCameraPermission()
        #endif
    }
    
    // MARK: - Camera Setup
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupScanner()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    granted ? self.setupScanner() : self.dismiss(animated: true)
                }
            }
        default:
            dismiss(animated: true)
        }
    }
    
    private func setupScanner() {
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            dismiss(animated: true)
            return
        }
        
        let session = AVCaptureSession()
        
        guard session.canAddInput(videoInput) else {
            dismiss(animated: true)
            return
        }
        
        session.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        guard session.canAddOutput(metadataOutput) else {
            dismiss(animated: true)
            return
        }
        
        session.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        metadataOutput.metadataObjectTypes = [
            .ean8,
            .ean13,
            .upce,
            .code128
        ]
        
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.frame = view.layer.bounds
        preview.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(preview)
        
        captureSession = session
        previewLayer = preview
        
        session.startRunning()
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    
    // MARK: - Delegate
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        captureSession?.stopRunning()
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            
            completion?(stringValue)
        }
        
        dismiss(animated: true)
    }
    
    // MARK: - Simulator Protection
    
    private func showSimulatorAlert() {
        let alert = UIAlertController(
            title: "Scanner non disponibile",
            message: "La fotocamera non è disponibile nel simulatore. Usa un dispositivo fisico.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
}
