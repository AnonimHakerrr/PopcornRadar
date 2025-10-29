import Foundation
import Combine

@MainActor
class BaseViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func fetchData<Owner: BaseViewModel, T>(
        on owner: Owner,
        loader: @escaping () async throws -> T,
        assignTo keyPath: ReferenceWritableKeyPath<Owner, T>
    ) async {
        owner.isLoading = true
        owner.errorMessage = nil
        
        do {
            let result = try await loader()
            owner[keyPath: keyPath] = result
        } catch {
            owner.errorMessage = "Помилка: \(error.localizedDescription)"
        }
        
        owner.isLoading = false
    }
    func fetchData<Owner: BaseViewModel, K: Hashable, V>(
        on owner: Owner,
        loader: @escaping () async throws -> V,
        assignToDict key: K,
        in dictKeyPath: ReferenceWritableKeyPath<Owner, [K: V]>
    ) async {
        owner.isLoading = true
        owner.errorMessage = nil
        
        do {
            let result = try await loader()
            var dict = owner[keyPath: dictKeyPath]
            dict[key] = result
            owner[keyPath: dictKeyPath] = dict
        } catch {
            owner.errorMessage = "Помилка: \(error.localizedDescription)"
        }
        
        owner.isLoading = false
    }
}
