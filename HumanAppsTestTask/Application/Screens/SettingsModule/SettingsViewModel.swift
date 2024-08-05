
import UIKit
import RxRelay

final class SettingsViewModel {
    
    private(set) var settingsSnapshotRelay = BehaviorRelay<SettingsSnapshot?>(value: nil)
    
    init() {
        createSnapshot()
    }
}

extension SettingsViewModel {
    func createSnapshot() {
        var snapshot = SettingsSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(createItems(), toSection: 0)
        
        settingsSnapshotRelay.accept(snapshot)
    }
    
    func createItems() -> [SettingsCollectionModel] {
        [SettingsCollectionModel(name: "Sergei Khotyanovich")]
    }
}

typealias SettingsSnapshot = NSDiffableDataSourceSnapshot<Int, SettingsCollectionModel>
