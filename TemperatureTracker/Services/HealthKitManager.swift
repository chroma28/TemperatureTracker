import Foundation
import HealthKit

enum HealthKitError: Error {
    case notAvailable
    case authorizationDenied
    case dataNotAvailable
    case unknown(Error)
}

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    private let bodyTemperatureType = HKQuantityType.quantityType(forIdentifier: .bodyTemperature)!
    
    enum AuthorizationStatus {
        case notDetermined
        case authorized
        case denied
    }
    
    @Published var authorizationStatus: AuthorizationStatus = .notDetermined
    
    init() {
        checkAuthorizationStatus()
    }
    
    private func checkAuthorizationStatus() {
        // Check if HealthKit is available on this device
        if !HKHealthStore.isHealthDataAvailable() {
            self.authorizationStatus = .denied
            return
        }
        
        // Check the current authorization status
        healthStore.getRequestStatusForAuthorization(toShare: [], read: [bodyTemperatureType]) { [weak self] (status, _) in
            DispatchQueue.main.async {
                switch status {
                case .unnecessary:
                    self?.authorizationStatus = .authorized
                case .shouldRequest:
                    self?.authorizationStatus = .notDetermined
                default:
                    self?.authorizationStatus = .denied
                }
            }
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        // Make sure HealthKit is available
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        
        // Define the types we need to access
        let typesToRead: Set<HKObjectType> = [bodyTemperatureType]
        
        // Request authorization
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { [weak self] (success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.authorizationStatus = .authorized
                } else {
                    self?.authorizationStatus = .denied
                }
                completion(success)
            }
        }
    }
    
    func fetchTemperatureData(from startDate: Date, to endDate: Date, completion: @escaping (Result<[TemperatureData], HealthKitError>) -> Void) {
        // Check if HealthKit is available
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(.failure(.notAvailable))
            return
        }
        
        // Set up the predicate for the date range
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        // Set up the descriptor for sorting by date
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        // Create the query
        let query = HKSampleQuery(sampleType: bodyTemperatureType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (_, samples, error) in
            
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }
            
            guard let temperatureSamples = samples as? [HKQuantitySample], !temperatureSamples.isEmpty else {
                completion(.success([]))
                return
            }
            
            // Map the HKQuantitySample to our TemperatureData model
            let temperatureData = temperatureSamples.map { sample in
                // Convert the temperature to Celsius (HealthKit stores body temperature in Celsius)
                let temperatureCelsius = sample.quantity.doubleValue(for: HKUnit.degreeCelsius())
                
                return TemperatureData(
                    id: sample.uuid,
                    timestamp: sample.endDate,
                    temperatureCelsius: temperatureCelsius
                )
            }
            
            completion(.success(temperatureData))
        }
        
        healthStore.execute(query)
    }
}
