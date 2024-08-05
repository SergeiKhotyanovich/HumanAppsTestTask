
import UIKit

final class SettingsCollectionViewCell: CollectionViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.Lufga.medium.font(size: 17)
        label.textColor = Asset.Colors.white.color
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.textAlignment = .center
        
        return label
    }()

    
    var viewModel: SettingsCollectionModel? {
        didSet {
            guard let viewModel else { return }
            
            nameLabel.text = viewModel.name
        }
    }
    
    override func setupStyle() {
        super.setupStyle()
        
        backgroundColor = Asset.Colors.watermelon.color
        layer.cornerRadius = 16
    }
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        
        addSubviews(nameLabel)
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}
