import Dependencies
import UseCase
import Repository

extension DependencyValues {
    public mutating func yeoBeeDependecy() {
        let expenseRepository = ExpenseRepository()
        let currencyRepository = CurrencyRepository()
        self.expenseUseCase = .live(expenseRepository: expenseRepository)
        self.currencyUseCase = .live(currencyRepository: currencyRepository)
    }
}
