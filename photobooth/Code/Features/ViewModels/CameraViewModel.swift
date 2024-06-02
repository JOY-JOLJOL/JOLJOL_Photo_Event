import SwiftUI
import AVFoundation

class CameraViewModel: ObservableObject {
    @Published var capturedImages: [UIImage] = [] {
        didSet {
            print("capturedImages changed: \(capturedImages)")
        }
    }
    @Published var remainingTime = 0
    @Published var mergedImage: UIImage? = nil
    @Published var count = 0

    var captureAction: (() -> Void)?
    var timer: Timer?
    var captureCount = 0

    func startCapturing() {
        // 실행 중 타이머 종료
        timer?.invalidate()
        captureCount = 0
        capturedImages.removeAll()
        remainingTime = 6
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }

    func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
        } else {
            if captureCount < 4 {
                captureAction?()
                remainingTime = 6
            } else {
                // 타이머 종료
                timer?.invalidate()
                timer = nil
                // 촬영 후 카운트
                count += 1
                print("Capture complete, merging images.")
                self.mergedImage = self.mergeImages()
                // 상태 초기화
                resetCameraState()
            }
        }
    }

    // 초기화
    private func resetCameraState() {
        // 촬영 목록 초기화
        capturedImages = []
        // 잔여 시간 초기화
        remainingTime = 0
        // 캡쳐 카운트 초기화
        captureCount = 0
    }

    func mergeImages() -> UIImage? {
        guard capturedImages.count == 4 else {
            print("Captured images count does not match expected. Found: \(capturedImages.count)")
            return nil
        }
        
//        let flippedImages = capturedImages.map { $0.withHorizontallyFlippedOrientation() ?? $0 }

        // 이미지 크기 조정
        let resizeWidth = capturedImages[0].size.width / 2
        let resizeHeight = capturedImages[0].size.height / 2
        let size = CGSize(width: resizeWidth * 2, height: resizeHeight * 2)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        for (index, image) in capturedImages.enumerated() {
            guard let resizedImage = image.resized(toWidth: resizeWidth) else {
                print("Failed to resize image at index \(index).")
                // 현재 이미지 컨텍스트 종료
                UIGraphicsEndImageContext()
                return nil
            }
            let x = CGFloat(index % 2) * resizeWidth
            let y = CGFloat(index / 2) * resizeHeight
            resizedImage.draw(in: CGRect(x: x, y: y, width: resizeWidth, height: resizeHeight))
        }
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let merged = mergedImage {
            print("Image merging successful.")
            return merged
        } else {
            print("Failed to merge images.")
            return nil
        }
    }

    func addExampleImage() {
        if let exampleImage = UIImage(named: "joljol_example") {
            capturedImages.append(exampleImage)
            captureCount += 1 // 예시 이미지 추가 후 촬영 횟수 증가
            print("Example image added to captured images.")
        } else {
            print("Failed to load example image.")
        }
    }
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
