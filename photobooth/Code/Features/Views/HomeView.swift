import SwiftUI


struct HomeView: View {
    
//    @State private var showingOnboardingView = false
    @State private var showingGetquantityView = false
    
    var body: some View {
        NavigationView {
            ZStack{
                // 배경 이미지 추가
                if let backgroundImage = UIImage(named: "home_background") {
                    Image(uiImage: backgroundImage)
                        .resizable()
                        .frame(width: 834, height: 1194)
                }
                GeometryReader { geometry in
                    VStack {
                        if let buttonImage = UIImage(named: "home_button") {
                            Button(action: {
                                // 버튼을 누를 때 네비게이션 링크를 활성화하기 위해 isActive를 true로 설정합니다.
                                showingGetquantityView = true
                            }) {
                                Image(uiImage: buttonImage)
                            }
                            .position(x: geometry.size.width * 284 / 834 + 266.4 / 2, y: geometry.size.height * 1056.8 / 1194 + 79.2 / 2)
                            .fullScreenCover(isPresented: $showingGetquantityView) {
                                GetquantityView() // 네비게이션 링크의 대상인 OnboardingView
                            }
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// SwiftUI 미리보기
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
