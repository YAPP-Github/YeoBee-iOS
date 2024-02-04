import Dependencies
import UseCase
import Repository

extension DependencyValues {
    public mutating func yeoBeeDependecy() {
        let repository = ExpenseRepository()
        self.expenseUseCase = .live(expenseRepository: repository)
    }
}
