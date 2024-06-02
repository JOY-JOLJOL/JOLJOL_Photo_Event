import SwiftUI
import AVFoundation

struct CustomCameraView: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        // Coordinator를 설정합니다.
        let coordinator = context.coordinator
        // coordinator에게 카메라 촬영 액션을 설정합니다.
        viewModel.captureAction = {
            if coordinator.captureSession.isRunning {
                coordinator.takePicture()
            } else {
                coordinator.useExampleImages()
            }
        }
        // UIScreen의 bounds를 사용하여 UIView의 프레임을 설정합니다.
        let view = UIView(frame: UIScreen.main.bounds)
        // coordinator를 사용하여 카메라 세션을 설정하는 메서드를 호출합니다.
        context.coordinator.setupCameraSession(for: view) // 뷰를 인자로 전달
        // 설정된 UIView를 반환합니다.
        return view
    }
    
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    //    private func checkCameraAuthorization(completion: @escaping (Bool) -> Void) {
    //        switch AVCaptureDevice.authorizationStatus(for: .video) {
    //        case .authorized:
    //            completion(true)
    //        case .notDetermined:
    //            AVCaptureDevice.requestAccess(for: .video) { granted in
    //                completion(granted)
    //            }
    //        default:
    //            completion(false)
    //        }
    //    }
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var viewModel: CameraViewModel // Coordinator가 참조하는 CameraViewModel 객체
        let captureSession = AVCaptureSession() // 카메라 캡처 세션
        let photoOutput = AVCapturePhotoOutput() // 사진을 캡처하는 데 사용되는 출력
        
        init(viewModel: CameraViewModel) {
            self.viewModel = viewModel
            super.init()
        }
        
        // 카메라 세션을 설정하는 메서드
        func setupCameraSession(for view: UIView) {
            // 카메라 세션의 preset을 사진으로 설정
            captureSession.sessionPreset = .photo
            
            // 전면 카메라 장치를 가져와서 입력으로 추가
            guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
                  let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
                  captureSession.canAddInput(videoInput) else {
                return
            }
            captureSession.addInput(videoInput)
            
            // 사진 출력을 세션에 추가
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            // 카메라 미리보기를 표시하기 위한 AVCaptureVideoPreviewLayer 설정
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            
            // 카메라 세션 시작
            captureSession.startRunning()
        }
        
        // 사진을 촬영하는 메서드
        func takePicture() {
            // 캡처가 가능한지를 먼저 확인
            if captureSession.isRunning {
                let settings = AVCapturePhotoSettings()
                photoOutput.capturePhoto(with: settings, delegate: self)
            } else {
                // 카메라 세션이 실행 중이 아니면 입력 이미지를 예시 이미지로 설정
                useExampleImages()
            }
        }
        
        // 사진 캡처 완료 후 호출되는 메서드
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            // AVCapturePhoto에서 UIImage로 변환하여 가져오기
            guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
            
            // 캡처된 이미지를 CameraViewModel에 추가
            appendImageToViewModel(image)
        }
        
        // 예시 이미지를 사용하여 CameraViewModel에 설정하는 메서드
        func useExampleImages() {
            print("Example image added to captured images.")
            // 예시 이미지를 가져옵니다.
            guard let exampleImage = UIImage(named: "joljol_example") else {
                print("Failed to load example image.")
                return
            }
            
            // 캡처된 이미지를 CameraViewModel에 추가하고 카운트 증가
            appendImageToViewModel(exampleImage)
        }
        
        // 이미지를 CameraViewModel에 추가하고 카운트를 증가시키는 메서드
        private func appendImageToViewModel(_ image: UIImage) {
            print("appendImageToViewModel")
            DispatchQueue.main.async {
                print("Function called")
                guard self.viewModel.captureCount < 4 else {
                    // 이미 4장의 사진을 캡처했다면, 타이머를 종료하고 이미지 합치기 작업을 진행합니다.
                    self.viewModel.timer?.invalidate()
                    self.viewModel.timer = nil
                    self.viewModel.mergedImage = self.viewModel.mergeImages()
                    return
                }
                
                // 캡처된 이미지를 좌우 반전시킨 후 배열에 추가합니다.
                if let flippedImage = image.withHorizontallyFlippedOrientation() {
                    self.viewModel.capturedImages.append(flippedImage)
                    print("Image added to captured images: \(flippedImage)")
                } else {
                    print("Failed to flip image horizontally.")
                }
                self.viewModel.captureCount += 1
                
                // 4장의 이미지가 모두 캡처되었는지 다시 확인하고, 모두 캡처되었다면 이미지를 합치는 작업을 진행합니다.
                if self.viewModel.capturedImages.count == 4 {
                    self.viewModel.mergedImage = self.viewModel.mergeImages()
                }
            }
        }

    }
}

extension UIImage {
    // UIImage를 좌우 반전시키는 함수
    func withHorizontallyFlippedOrientation() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: .leftMirrored)
    }
}
