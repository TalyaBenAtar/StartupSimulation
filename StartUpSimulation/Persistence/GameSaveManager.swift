//
//  GameSaveManager.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 18/07/2026.
//

import Foundation

final class GameSaveManager {

    // MARK: - Singleton

    static let shared = GameSaveManager()

    // MARK: - File Name

    private let saveFileName =
        "startup_simulation_save.json"

    private init() {}

    // MARK: - Save Location

    private var saveFileURL: URL? {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?
            .appendingPathComponent(
                saveFileName
            )
    }

    // MARK: - Save

    func save(
        _ saveData: GameSaveData
    ) {
        guard let saveFileURL else {
            print(
                "Failed to find the Documents directory."
            )
            return
        }

        do {
            let encoder = JSONEncoder()

            encoder.outputFormatting = [
                .prettyPrinted,
                .sortedKeys
            ]

            let encodedData =
                try encoder.encode(
                    saveData
                )

            try encodedData.write(
                to: saveFileURL,
                options: .atomic
            )

            print(
                "Game saved successfully."
            )
        } catch {
            print(
                "Failed to save game: \(error.localizedDescription)"
            )
        }
    }

    // MARK: - Load

    func load() -> GameSaveData? {
        guard let saveFileURL else {
            print(
                "Failed to find the Documents directory."
            )
            return nil
        }

        guard FileManager.default.fileExists(
            atPath: saveFileURL.path
        ) else {
            print(
                "No saved game was found."
            )
            return nil
        }

        do {
            let savedData =
                try Data(
                    contentsOf: saveFileURL
                )

            let decoder = JSONDecoder()

            let decodedSave =
                try decoder.decode(
                    GameSaveData.self,
                    from: savedData
                )

            print(
                "Game loaded successfully."
            )

            return decodedSave
        } catch {
            print(
                "Failed to load game: \(error.localizedDescription)"
            )

            return nil
        }
    }

    // MARK: - Save Availability

    var hasSavedGame: Bool {
        guard let saveFileURL else {
            return false
        }

        return FileManager.default.fileExists(
            atPath: saveFileURL.path
        )
    }

    // MARK: - Delete

    func deleteSave() {
        guard let saveFileURL else {
            return
        }

        guard FileManager.default.fileExists(
            atPath: saveFileURL.path
        ) else {
            return
        }

        do {
            try FileManager.default.removeItem(
                at: saveFileURL
            )

            print(
                "Saved game deleted successfully."
            )
        } catch {
            print(
                "Failed to delete saved game: \(error.localizedDescription)"
            )
        }
    }
}
