import UIKit

extension UIViewController {
    /// 확인 버튼 1개만 존재하는 기본 알럿 띄우기
    func showAlertWithOKButton(
        title: String,
        message: String? = nil,
        buttonLabel: String = "확인",
        onCompletion: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonLabel, style: .default, handler: onCompletion)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
