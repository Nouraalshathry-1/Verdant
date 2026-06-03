
@preconcurrency import AVFoundation
import SwiftUI

struct CameraPreviewView: UIViewRepresentable {
    var onFrame: (CVPixelBuffer) -> Void

    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.onFrame = onFrame
        return view
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {
        uiView.onFrame = onFrame
    }
}

@MainActor
class PreviewUIView: UIView {
    var onFrame: ((CVPixelBuffer) -> Void)?
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var lastClassifiedTime: Date = .distantPast
    private let cameraQueue = DispatchQueue(label: "cameraQueue")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCamera()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCamera()
    }

    private func setupCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .high

        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else { return }

        session.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]

        let delegate = CameraDelegate { [weak self] pixelBuffer in
            guard let self else { return }
            let now = Date()
            guard now.timeIntervalSince(self.lastClassifiedTime) >= 1.0 else { return }
            self.lastClassifiedTime = now
            self.onFrame?(pixelBuffer)
        }
        output.setSampleBufferDelegate(delegate, queue: cameraQueue)
        objc_setAssociatedObject(self, "delegate", delegate, .OBJC_ASSOCIATION_RETAIN)

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspectFill
        layer.addSublayer(preview)
        self.previewLayer = preview

        cameraQueue.async {
            session.startRunning()
        }
        self.captureSession = session
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}

final class CameraDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let handler: (CVPixelBuffer) -> Void

    init(handler: @escaping (CVPixelBuffer) -> Void) {
        self.handler = handler
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        handler(pixelBuffer)
    }
}
