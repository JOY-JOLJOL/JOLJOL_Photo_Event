import SwiftUI
import AVFoundation

struct OnboardingView: View {
    
    @State private var showingTakePhotoView = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            // 배경 이미지 추가
            if let backgroundImage = UIImage(named: "onboarding_background") {
                Image(uiImage: backgroundImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .edgesIgnoringSafeArea(.all)
            }
            VStack {
                if let buttonImage = UIImage(named: "takephoto_button") {
                    Button(action: {
                        // 버튼을 누를 때 네비게이션 링크를 활성화하기 위해 isActive를 true로 설정합니다.
                        showingTakePhotoView = true
                    }) {
                        Image(uiImage: buttonImage)
                    }
                    .position(x: 284 + 266.4 / 2, y: 1056.8 + 79.2 / 2)
                    .fullScreenCover(isPresented: $showingTakePhotoView) {
                        TakePhotoView() // 네비게이션 링크의 대상인 TakePhotoView
                    }
                }
            }
        }
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                // 사용자가 카메라 접근을 허용
                print("카메라 접근 허용됨")
            } else {
                // 사용자가 카메라 접근을 거부
                print("카메라 접근 거부됨")
            }
        }
    }
}

// SwiftUI 미리보기
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
