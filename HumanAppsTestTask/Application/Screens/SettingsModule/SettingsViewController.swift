
import UIKit

final class SettingsViewController: ViewController {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionLayout())
        collectionView.register(SettingsCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

        return collectionView
    }()
    
    fileprivate lazy var dataSource: UICollectionViewDiffableDataSource<Int, SettingsCollectionModel> = {
        UICollectionViewDiffableDataSource<Int, SettingsCollectionModel>(collectionView: collectionView) { [weak self] collectionView, indexPath, cellModel in
            let cell = collectionView.dequeue(SettingsCollectionViewCell.self, for: indexPath)
            cell.viewModel = cellModel

            return cell
        }
    }()
    
    var viewModel: SettingsViewModel!
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        
        view.addSubviews(collectionView)
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewModel.settingsSnapshotRelay.asDriver()
            .compactMap { $0 }
            .drive(onNext: { [weak self] snapshot in
                self?.dataSource.apply(snapshot, animatingDifferences: true)
        }).disposed(by: disposeBag)
    }
    
    private func createCollectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
