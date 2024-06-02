import SwiftUI
import AVFoundation

// 사진을 찍는 데 사용되는 SwiftUI 뷰
struct TakePhotoView: View {

    // 카메라 관련 기능을 관리하는 CameraViewModel
    @StateObject private var cameraViewModel = CameraViewModel()
    
    // 결과 뷰와 플래시 효과를 관리하는 상태 변수
    @State private var isPresentingResultView = false
    @State private var flash = false

    var body: some View {
        ZStack {
            // 뷰의 배경 이미지
            if let backgroundImage = UIImage(named: "takephoto_background") {
                Image(uiImage: backgroundImage)
            }
            
            // 카메라 뷰
            CustomCameraView(viewModel: cameraViewModel)
                .frame(width: 558, height: 842)
                .clipped()
                .position(x: 138 + 558 / 2, y: 294 + 842 / 2)
                // 뷰가 나타날 때 카메라 캡처를 시작
                .onAppear {
                    cameraViewModel.startCapturing()
                }
                // 결과 뷰를 전체 화면으로 표시
                .fullScreenCover(isPresented: $isPresentingResultView) {
                    // 결과 뷰에서 병합된 이미지 표시
                    if let exampleImage = UIImage(named: "joljol_example") {
                        ResultView(mergedImage: cameraViewModel.mergedImage ?? exampleImage)
                    } else {
                        ResultView(mergedImage: UIImage())
                    }
                }
                // 카메라 뷰 모델의 mergedImage가 변경될 때 결과 뷰를 표시
                .onChange(of: cameraViewModel.mergedImage) {
                    // mergedImage의 상태 변화가 감지되면, isPresentingResultView를 true로 설정하여 sheet를 표시합니다.
                    withAnimation {
                        flash = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            flash = false
                        }
                    }
                    isPresentingResultView = cameraViewModel.mergedImage != nil
                }
                // 반짝이는 효과를 구현합니다.
                .overlay(
                    flash ? Color.white.opacity(0.8) : Color.clear
                )
            
//            VStack {
//                if cameraViewModel.capturedImages.isEmpty {
//                    // 아직 사진을 찍지 않았다면 예시 이미지를 표시
//                    if let exampleImage = UIImage(named: "joljol_example") {
//                        Image(uiImage: exampleImage)
//                            .resizable()
//                            .frame(width: 558, height: 842)
//                            .clipped()
//                            .position(x: 138 + 558 / 2, y: 294 + 842 / 2)
//                    } else {
//                        Text("예시 이미지를 찾을 수 없습니다")
//                            .foregroundColor(.red)
//                    }
//                } else {
//                    
//                }
//            }
            
            // 남은 시간과 찍은 사진 수를 표시
            if cameraViewModel.remainingTime > 0 {
                Text("\(cameraViewModel.capturedImages.count)")
                    .font(.custom("GangwonEduSaeeum OTF", size: 45))
                    .foregroundColor(.black)
                    .position(x: 361 + 20 / 2, y: 63 + 52 / 2)
                Text("\(cameraViewModel.remainingTime)")
                    .font(.custom("GangwonEduSaeeum OTF", size: 86.85))
                    .foregroundColor(.ewhagreen)
                    .position(x: 382 + 41 / 2, y: 135.53 + 99 / 2)
            } else {
                // 시간이 다 되었다면, 찍은 사진 수와 메시지를 표시
                Text("\(cameraViewModel.capturedImages.count)")
                    .font(.custom("GangwonEduSaeeum OTF", size: 45))
                    .foregroundColor(.black)
                    .position(x: 361 + 20 / 2, y: 63 + 52 / 2)
                Text("0")
                    .font(.custom("GangwonEduSaeeum OTF", size: 86.85))
                    .foregroundColor(.ewhagreen)
                    .position(x: 382 + 41 / 2, y: 135.53 + 99 / 2)
                Text("J-O-Y-!")
                    .font(.custom("GangwonEduSaeeum OTF", size: 86.85))
                    .foregroundColor(.ewhagreen)
                    .position(x: 291 + 252 / 2, y: 400)
            }
        }
    }
}

// SwiftUI 미리보기용 TakePhotoView
struct TakePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        TakePhotoView()
    }
}
