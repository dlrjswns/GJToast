
import UIKit

final public class GJToast: UIView {
  
  // MARK: - Property
  
  private let toastMessage: String
  private let toastImage: UIImage?
  private let duration: Duration
  private let priority: GJToastPriority
  private static var priorityQueue: [GJToast] = []
  
  // MARK: - UI Components
  
  private let containerView = {
    $0.axis = .horizontal
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    $0.alignment = .center
    $0.spacing = 4
    return $0
  }(UIStackView())
  
  private let messageLabel = {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 12, weight: .regular)
    return $0
  }(UILabel())
  
  private lazy var toastImageView = {
    $0.contentMode = .scaleAspectFit
    return $0
  }(UIImageView())
  
  // MARK: - Initializations
  
  private init(toastMessage: String, toastImage: UIImage?, duration: Duration = .short, priority: GJToastPriority = .normal) {
    self.duration = duration
    self.toastMessage = toastMessage
    self.toastImage = toastImage
    self.priority = priority
    super.init(frame: .zero)
    setupLayouts()
    setupStyles()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configurations
  
  private func setupLayouts() {
    addSubview(containerView)
    if let _ = toastImage {
      containerView.addArrangedSubview(toastImageView)
    }
    containerView.addArrangedSubview(messageLabel)
  }
  
  private func setupConstraints() {
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    containerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
    containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
    toastImageView.translatesAutoresizingMaskIntoConstraints = false
    toastImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
    toastImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
  }
  
  private func setupStyles() {
    if let toastImage = toastImage {
      toastImageView.image = toastImage
    }
    messageLabel.text = toastMessage
    backgroundColor = .black.withAlphaComponent(0.3)
    layer.cornerRadius = 8
    clipsToBounds = true
    alpha = 0
  }
  
  @available(iOS 13.0, *)
  public static func makeToast(_ toastMessage: String, toastImage: UIImage? = nil) {
    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
      return
    }
    
    let toast = GJToast(toastMessage: toastMessage, toastImage: toastImage)
    
    window.addSubview(toast)
    toast.translatesAutoresizingMaskIntoConstraints = false
    toast.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    toast.heightAnchor.constraint(equalToConstant: 50).isActive = true
    toast.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: 10).isActive = true
    toast.trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor, constant: -10).isActive = true
    toast.widthAnchor.constraint(lessThanOrEqualToConstant: window.frame.width).isActive = true
    toast.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
    
//    priorityQueue.append(toast)
//    
//    if priorityQueue.contains(where: { $0.priority.rawValue >= toast.priority.rawValue }) {
//      priorityQueue.
//    }
    
    toast.showToast()
  }
  
  private func showToast() {
    UIView.animate(
      withDuration: 0.25,
      delay: 0,
      options: .curveEaseIn) {
        self.alpha = 1
      } completion: { _ in
        self.hideToast()
      }
  }
  
  /// 지속시간이 지난 이후 다시 alpha값을 0으로 만들어 Toast가 사라지도록 만듭니다.
  private func hideToast() {
    UIView.animate(
      withDuration: 0.25,
      delay: duration.value,
      options: .curveEaseOut) {
        self.alpha = 0
      } completion: { _ in
        self.removeToast()
      }
  }
  
  /// Toast를 제거합니다.
  private func removeToast() {
    self.removeFromSuperview()
  }
}

extension GJToast {
  
  /// GJToast의 지속시간
  public enum Duration {
    case short
    case long
    
    var value: Double {
      switch self {
      case .short:
        return 1.5
      case .long:
        return 3
      }
    }
  }
  
  /// 어떤 GJToast를 먼저 보여줄지에 대한 우선순위
  public enum GJToastPriority: Comparable, RawRepresentable {
    
    public typealias RawValue = Float
    
    case required
    case high
    case normal
    case low
    
    public static func < (lhs: GJToast.GJToastPriority, rhs: GJToast.GJToastPriority) -> Bool {
      return lhs.rawValue < rhs.rawValue
    }
    
    public var rawValue: Float {
      switch self {
      case .required:
        return 1000
      case .high:
        return 750
      case .normal:
        return 500
      case .low:
        return 250
      }
    }
    
    public init(rawValue: Float) {
      if rawValue >= 250 {
        self = .low
      } else if 250 < rawValue && rawValue <= 500 {
        self = .normal
      } else if 500 < rawValue && rawValue <= 750 {
        self = .high
      } else {
        self = .required
      }
    }

  }
}

//extension GJToast {
//  public enum GJToastType {
//
//    /// GJToast에서 제공하는 기본적인 타입
//    case system(SystemType)
//
//    /// 사용자 편의에 맞게 꾸밀 수 있는 타입
//    case custom
//  }
//
//  public enum SystemType {
//    case success
//    case failure
//
//    var message: String {
//      switch self {
//      case .success:
//        return "성공했습니다 :)"
//      case .failure:
//        return "실패했습니다 -ㅅ-"
//      }
//    }
//
//    @available(iOS 13.0, *)
//    var image: UIImage {
//      switch self {
//      case .success:
//        return UIImage(systemName: "checkmark")!
//      case .failure:
//        return UIImage(systemName: "exclamationmark")!
//      }
//    }
//  }
//}

