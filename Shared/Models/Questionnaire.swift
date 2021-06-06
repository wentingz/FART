import Combine
import Foundation

enum ApproachType: String {
    case precision
    case nonprecision
    case none
    case circling
    case notApplicable // for VFR flights
}

enum Category {
    case pilot
    case airport
    case environment
    case external
    case none
}

var pilotKeyPaths: Set<KeyPath<Questionnaire, Bool>> = [\.lessThan50InType, \.lessThan15InLast90, \.afterWork, \.lessThan8HrSleep, \.dualInLast90, \.wingsInLast6Mo, \.IFRCurrent]

var airportKeyPaths: Set<KeyPath<Questionnaire, Bool>> = [\.mountainous, \.nontowered, \.shortRunway, \.wetOrSoftFieldRunway, \.runwayObstacles, \.noDestWx]

var environmentKeyPaths: Set<KeyPath<Questionnaire, Bool>> = [\.night, \.strongWinds, \.strongCrosswinds, \.vfrCeilingUnder3000, \.vfrVisibilityUnder5, \.ifrLowCeiling, \.ifrLowVisibility]
 
var externalKeyPaths: Set<KeyPath<Questionnaire, Bool>> = [\.vfrFlightPlan, \.vfrFlightFollowing]

var riskCategories = [Category.pilot : pilotKeyPaths, Category.airport : airportKeyPaths, Category.environment : environmentKeyPaths, Category.external : externalKeyPaths]

class Questionnaire: ObservableObject {
    @Published var lessThan50InType = false
    @Published var lessThan15InLast90 = false
    @Published var afterWork = false
    @Published var lessThan8HrSleep = false
    @Published var dualInLast90 = false
    @Published var wingsInLast6Mo = false
    @Published var IFRCurrent = false
    
    @Published var night = false
    @Published var strongWinds = false
    @Published var strongCrosswinds = false
    @Published var mountainous = false
    
    @Published var nontowered = false
    @Published var shortRunway = false
    @Published var wetOrSoftFieldRunway = false
    @Published var runwayObstacles = false
    
    @Published var vfrCeilingUnder3000 = false
    @Published var vfrVisibilityUnder5 = false
    @Published var noDestWx = false
    @Published var vfrFlightPlan = false
    @Published var vfrFlightFollowing = false
    @Published var ifrLowCeiling = false
    @Published var ifrLowVisibility = false
    @Published var ifrApproachType = ApproachType.notApplicable
    
    @Published var score = 0
    @Published var pilotScore = 0
    @Published var airportScore = 0
    @Published var environmentScore = 0
    @Published var externalFactorScore = 0

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $lessThan50InType.receive(on: RunLoop.main)
            .sink { _ in self.pilotScore = self.calculateScore(category: Category.pilot) }
            .store(in: &cancellables)
        $lessThan15InLast90.receive(on: RunLoop.main)
            .sink { _ in self.pilotScore = self.calculateScore(category: Category.pilot) }
            .store(in: &cancellables)
        $afterWork.receive(on: RunLoop.main)
            .sink { _ in self.pilotScore = self.calculateScore(category: Category.pilot) }
            .store(in: &cancellables)
        $lessThan8HrSleep.receive(on: RunLoop.main)
            .sink { _ in self.pilotScore = self.calculateScore(category: Category.pilot) }
            .store(in: &cancellables)
        $dualInLast90.receive(on: RunLoop.main)
            .sink { _ in self.pilotScore = self.calculateScore(category: Category.pilot) }
            .store(in: &cancellables)
        $wingsInLast6Mo.receive(on: RunLoop.main)
            .sink { _ in self.pilotScore = self.calculateScore(category: Category.pilot) }
            .store(in: &cancellables)
        $IFRCurrent.receive(on: RunLoop.main)
            .sink { _ in self.pilotScore = self.calculateScore(category: Category.pilot) }
            .store(in: &cancellables)
        $mountainous.receive(on: RunLoop.main)
            .sink { _ in self.airportScore = self.calculateScore(category: Category.airport) }
            .store(in: &cancellables)
        $nontowered.receive(on: RunLoop.main)
            .sink { _ in self.airportScore = self.calculateScore(category: Category.airport) }
            .store(in: &cancellables)
        $shortRunway.receive(on: RunLoop.main)
            .sink { _ in self.airportScore = self.calculateScore(category: Category.airport) }
            .store(in: &cancellables)
        $wetOrSoftFieldRunway.receive(on: RunLoop.main)
            .sink { _ in self.airportScore = self.calculateScore(category: Category.airport) }
            .store(in: &cancellables)
        $runwayObstacles.receive(on: RunLoop.main)
            .sink { _ in self.airportScore = self.calculateScore(category: Category.airport) }
            .store(in: &cancellables)
        $noDestWx.receive(on: RunLoop.main)
            .sink { _ in self.airportScore = self.calculateScore(category: Category.airport) }
            .store(in: &cancellables)
        $vfrCeilingUnder3000.receive(on: RunLoop.main)
            .sink { _ in self.environmentScore = self.calculateScore(category: Category.environment) }
            .store(in: &cancellables)
        $vfrVisibilityUnder5.receive(on: RunLoop.main)
            .sink { _ in self.environmentScore = self.calculateScore(category: Category.environment) }
            .store(in: &cancellables)
        $night.receive(on: RunLoop.main)
            .sink { _ in self.environmentScore = self.calculateScore(category: Category.environment) }
            .store(in: &cancellables)
        $strongWinds.receive(on: RunLoop.main)
            .sink { _ in self.environmentScore = self.calculateScore(category: Category.environment) }
            .store(in: &cancellables)
        $strongCrosswinds.receive(on: RunLoop.main)
            .sink { _ in self.environmentScore = self.calculateScore(category: Category.environment) }
            .store(in: &cancellables)
        $ifrLowCeiling.receive(on: RunLoop.main)
            .sink { _ in self.environmentScore = self.calculateScore(category: Category.environment) }
            .store(in: &cancellables)
        $ifrLowVisibility.receive(on: RunLoop.main)
            .sink { _ in self.environmentScore = self.calculateScore(category: Category.environment) }
            .store(in: &cancellables)
        $vfrFlightFollowing.receive(on: RunLoop.main)
            .sink { _ in self.externalFactorScore = self.calculateScore(category: Category.external) }
            .store(in: &cancellables)
        $vfrFlightPlan.receive(on: RunLoop.main)
            .sink { _ in self.externalFactorScore = self.calculateScore(category: Category.external) }
            .store(in: &cancellables)
        $ifrApproachType.receive(on: RunLoop.main)
            .sink { _ in self.airportScore = self.calculateScore(category: Category.airport) }
            .store(in: &cancellables)
        $pilotScore.receive(on: RunLoop.main)
            .sink { _ in self.score = self.calculateScore(category: Category.none) }
            .store(in: &cancellables)
        $airportScore.receive(on: RunLoop.main)
            .sink { _ in self.score = self.calculateScore(category: Category.none) }
            .store(in: &cancellables)
        $environmentScore.receive(on: RunLoop.main)
            .sink { _ in self.score = self.calculateScore(category: Category.none) }
            .store(in: &cancellables)
        $externalFactorScore.receive(on: RunLoop.main)
            .sink { _ in self.score = self.calculateScore(category: Category.none) }
            .store(in: &cancellables)
    }
        
    deinit {
        for cancellable in cancellables { cancellable.cancel() }
    }
    
    func calculateScore(category: Category) -> Int {
        if (category != Category.none) {
            return calculateCategoryScore(category: category)
        }
        let score = calculateCategoryScore(category: Category.pilot) +
        calculateCategoryScore(category: Category.airport) +
        calculateCategoryScore(category: Category.environment) +
        calculateCategoryScore(category: Category.external)

        return max(0, score)
    }
    
    func calculateCategoryScore(category: Category) -> Int {
        var score = 0
        for keypath in riskCategories[category]! {
            score = score + questionScorer(for: keypath).score(self[keyPath: keypath])
        }
        if (category == Category.airport) {
            score = score + questionScorer(for: \.ifrApproachType).score(ifrApproachType)
        }
        return score
}
}
