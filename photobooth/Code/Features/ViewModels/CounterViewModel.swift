import SwiftUI
import Combine

class CounterViewModel: ObservableObject {
    @Published var counter = 2
    
    func incrementCounter() {
        if counter < 8 {
            counter += 2
        }
    }
    
    func decrementCounter() {
        if counter > 2 {
            counter -= 2
        }
    }
}
