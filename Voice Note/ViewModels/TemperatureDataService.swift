// 
// Created by Anwar Ulhaq on 25.4.2023.
// 
// 

import Foundation

/**
    A class that provides service related to temperature data.
    An instance of this class is Singleton
 */
class TemperatureDataService {
    @Published private(set) var temperatures: [Temperature] = []
    @Published private(set) var isLoading = false

    static let sharedLocationService = TemperatureDataService()
    private var request: TemperatureAPIRequest<TemperatureResource>?

    private func loadLocationsFromCoreData() -> [Location] {
        CoreDataService.localStorage.fetchAllVoiceNotes().map { voiceNote -> Location? in
                    voiceNote.location
                }
                .compactMap {$0}
    }

    private init() {

    }
    func fetchLatestTemperatures() async {

        _ = await withTaskGroup(of: (Temperature?, VoiceNote?).self) { group in
            for voiceNote in CoreDataService.localStorage.fetchAllVoiceNotes() {
                if let location = voiceNote.location {
                    group.addTask { [self] in
                        async let temps = try? await loadCurrentTemperature(atLocation: location)
                        return (await temps, voiceNote)
                    }
                }
            }

            let context = CoreDataService.localStorage.getManageObjectContext()
            var latestTemps: [(Temperature, VoiceNote)] = []

            for await result in group {
                if let newTemperature = result.0, let voiceNote = result.1 {
                    voiceNote.weather?.temperature = newTemperature
                    do {
                        try context.save()
                    } catch {
                        print(#function, "Error saving temperature")
                    }
                }
            }
            return latestTemps
        }
    }

    func loadSevenDaysTemperature(atLocation: Location) async throws -> [Temperature] {
        try await fetchNextSevenDaysTemperatureAt(location: atLocation).map { temperatureResponse -> Temperature in
            temperatureResponse.temperature
        }
    }

    func loadCurrentTemperature(atLocation: Location) async throws -> Temperature? {
        return try await fetchNextSevenDaysTemperatureAt(location: atLocation).first?.temperature
    }

    private func fetchNextSevenDaysTemperatureAt(location: Location) async throws -> [TemperatureResponse] {
        var temperatureResponses: [TemperatureResponse] = []
        let resource = TemperatureResource(
                resourceURL: "https://www.7timer.info",
                methodPath: "/bin/api.pl",
                filters: [
                    ("lon", "\(String(location.longitude))"),
                    ("lat", "\(String(location.latitude))"),
                    ("product", "civillight"), ("output", "json")
                ])
        let request = TemperatureAPIRequest(resource: resource)
        self.request = request

        try await request.execute { [weak self] response in
            temperatureResponses = response ?? []
        }
        return temperatureResponses
    }
}