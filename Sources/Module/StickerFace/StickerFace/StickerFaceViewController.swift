import UIKit
import WebKit
import SkeletonView

class StickerFaceViewController: ViewController<StickerFaceView> {

    enum PageType {
        case editor
        case main
    }
    
    // MARK: Properties
    
    weak var editorDelegate: StikerFaceEditorDelegate?
    
    private var layers: String
    private var requestId = 0
    
    private var type: PageType = .main {
        didSet {
            updateChild()
        }
    }
    
    // MARK: Initalization
    
    init(type: PageType, layers: String) {
        self.type = type
        self.layers = layers
        super.init(nibName: nil, bundle: nil)
        
        if let url = URL(string: "https://stickerface.io/render.html") {
            mainView.renderWebView.load(URLRequest(url: url))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.editorViewController.delegate = self
        editorDelegate = mainView.editorViewController
        
        addChildViewController(mainView.editorViewController)
        mainView.editorViewController.didMove(toParentViewController: self)
        
        addChildViewController(mainView.mainViewController)
        mainView.mainViewController.didMove(toParentViewController: self)
        
        updateChild()
        
        mainView.renderWebView.navigationDelegate = self
        
        do {
            let handler = AvatarRenderResponseHandler()
            handler.delegate = self
        
            mainView.renderWebView.configuration.userContentController.add(handler, name: handler.name)
        }
    }
    
    // MARK: Private methods
    
    private func updateChild() {
        mainView.editorViewController.view.alpha = type == .editor ? 1 : 0
        mainView.mainViewController.view.alpha = type == .main ? 1 : 0
    }
    
    private func renderAvatar() {
        let tuple = editorDelegate?.layersWithoutBackground(layers)
        let id = getNextRequestId()
        let renderFunc = createRenderFunc(requestId: id, layers: tuple?.layers ?? "", size: Int(AvatarView.Layout.avatarImageViewHeight) * 4)
        
        mainView.renderWebView.evaluateJavaScript(renderFunc)
        
        ImageLoader.setAvatar(with: tuple?.background,
                              for: mainView.backgroundImageView,
                              placeholderImage: mainView.backgroundImageView.image ?? UIImage(),
                              side: mainView.bounds.width,
                              cornerRadius: 0)
    }
    
    private func createRenderFunc(requestId: Int, layers: String, size: Int) -> String {
        return "renderPNG(\"\(layers)\", \(requestId), \(size))"
    }
    
    private func getNextRequestId() -> Int {
        let current = requestId
        requestId = (current + 1) % Int.max
        
        return current
    }

}

// MARK: - StickerFaceEditorViewControllerDelegate
extension StickerFaceViewController: StickerFaceEditorViewControllerDelegate {
    func stickerFaceEditorViewControllerShouldContinue(_ controller: StickerFaceEditorViewController) {
        type = type == .editor ? .main : .editor
    }
    
    func stickerFaceEditorViewController(_ controller: StickerFaceEditorViewController, didUpdate layers: String) {
        self.layers = layers
        renderAvatar()
    }
}

// MARK: - AvatarRenderResponseHandlerDelegate
extension StickerFaceViewController: AvatarRenderResponseHandlerDelegate {
    
    func onImageReady(base64: String) {
        if let data = Data(base64Encoded: base64, options: []) {
            mainView.avatarView.avatarImageView.image = UIImage(data: data)
            mainView.avatarView.hideSkeleton()
        }
    }
    
}

// MARK: - WKScriptMessageHandler
extension StickerFaceViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        renderAvatar()
    }
    
}