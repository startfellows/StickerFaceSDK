import UIKit
import SnapKit
import WebKit
import SkeletonView

class StickerFaceEditorView: RootView {
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    let renderWebView: WKWebView = {
        let webView = WKWebView()
        webView.alpha = 0
        
        return webView
    }()
    
    let tonBalanceView: TonBalanceView = {
        let view = TonBalanceView()
        view.layer.cornerRadius = 16
         
        return view
    }()
    
    let avatarView: AvatarView = {
        let avatarView = AvatarView()
        avatarView.layer.cornerRadius = AvatarView.Layout.avatarImageViewHeight / 2
        avatarView.layer.masksToBounds = true
        avatarView.isSkeletonable = true
        
        return avatarView
    }()
        
    let headerCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(libraryNamed: "stickerFaceSeparator")
        
        return view
    }()
        
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("commonSaveButtonTitle".libraryLocalized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Palette.fontBold.withSize(18.0)
        button.backgroundColor = UIColor(libraryNamed: "stickerFaceAccent")
        button.layer.cornerRadius = 24.0
        
        return button
    }()
    
    let loaderView = LoaderView()

    override func setup() {
        
        backgroundColor = .gray
        
        addSubview(tonBalanceView)
        addSubview(renderWebView)
        addSubview(avatarView)
        addSubview(headerCollectionView)
        addSubview(separator)
        addSubview(pageViewController.view)
        addSubview(saveButton)
        addSubview(loaderView)
        
        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        pageViewController.view.frame = CGRect(x: 0, y: separator.frame.maxY, width: bounds.width, height: bounds.height - separator.frame.maxY)
    }
    
    private func setupConstraints() {
        avatarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(64.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(AvatarView.Layout.avatarImageViewHeight)
        }
        
        renderWebView.snp.makeConstraints { make in
            make.edges.equalTo(avatarView.snp.edges)
        }
        
        headerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(57.0)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(headerCollectionView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1.0)
        }
        
        saveButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-20.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20.0)
            make.height.equalTo(48.0)
        }
        
        tonBalanceView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8.0)
        }
        
    }

}
