import SwiftUI

struct GetquantityView: View {
    
    @State private var showingOnboardingView = false
    @StateObject private var viewModel = CounterViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            // 배경 이미지 추가
            if let backgroundImage = UIImage(named: "getquantity_background") {
                Image(uiImage: backgroundImage)
                    .resizable()
                    .frame(width: 834, height: 1194)
            }
            GeometryReader { geometry in
                VStack {
                    // 피그마에서 내보낸 버튼 이미지 사용
                    if let buttonImage1 = UIImage(named: "getquantity_button_up") {
                        Button(action: {
                            // ViewModel의 함수를 호출하여 숫자 증가
                            viewModel.incrementCounter()
                        }) {
                            Image(uiImage: buttonImage1)
                        }
//                        .position(x: 409, y: 403)
                        .position(x: geometry.size.width * 403 / 834 + 43.2 / 2, y: geometry.size.height * 409 / 1194 + 22.4 / 2)
                    }
                    Text("\(viewModel.counter)")
                    .font(
                        .custom("GangwonEduSaeeum OTF", size: 123.30618)
                    .weight(.medium)
                    )
                    .position(x: geometry.size.width * 384.65 / 834 + 50 / 2, y: geometry.size.height * 180 / 1194 + 141 / 2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    if let buttonImage2 = UIImage(named: "getquantity_button_down") {
                        Button(action: {
                            // ViewModel의 함수를 호출하여 숫자 감소
                            viewModel.decrementCounter()
                        }) {
                            Image(uiImage: buttonImage2)
                        }
                        .position(x: geometry.size.width * 403 / 834 + 43.2 / 2, y: geometry.size.height * 15 / 1194)
                    }
                }
            }
            VStack {
                if let buttonImage = UIImage(named: "takephoto_button") {
                    Button(action: {
                        // 버튼을 누를 때 네비게이션 링크를 활성화하기 위해 isActive를 true로 설정합니다.
                        showingOnboardingView = true
                    }) {
                        Image(uiImage: buttonImage)
                    }
                    .position(x: 284 + 266.4 / 2, y: 1056.8 + 79.2 / 2)
                    .fullScreenCover(isPresented: $showingOnboardingView) {
                        OnboardingView() // 네비게이션 링크의 대상인 OnboardingView
                    }
                }
            }
        }
    }
}

// SwiftUI 미리보기
struct GetquantityView_Previews: PreviewProvider {
    static var previews: some View {
        GetquantityView()
    }
}
