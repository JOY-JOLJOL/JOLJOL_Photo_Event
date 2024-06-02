import SwiftUI


struct GoodbyeView: View {
    
    @State private var showingOnlystaffView = false
    
    var body: some View {
        NavigationView {
            ZStack{
                // 배경 이미지 추가
                if let backgroundImage = UIImage(named: "goodbye_background") {
                    Image(uiImage: backgroundImage)
                        .resizable()
                        .frame(width: 834, height: 1194)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// SwiftUI 미리보기
struct GoodbyeView_Previews: PreviewProvider {
    static var previews: some View {
        GoodbyeView()
    }
}
