import SwiftUI
import UIKit

extension UIViewController {
    /// SwiftUI 뷰를 동적으로 높이가 조정되는 커스텀 시트를 생성하는 함수
    /// 원하는 배경 뷰와 내용 뷰를 지정하고, 고정된 높이도 지정할 수 있다.
    func presentCustomSheet<Content: View>(
        content: Content,
        backgroundView: UIView? = nil,
        sheetHeight: CGFloat? = nil,
        detentIdentifier: String = "fixedHeight",
        animated: Bool = true,
        isNavigationController: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        // 1. UIViewController 생성
        let viewController = setupBackgroundViewController(with: backgroundView)
        
        // 2. 뷰컨트롤러에 Hosting Controller 추가
        let hostingController = UIHostingController(rootView: content)
        setupHostingController(viewController, hostingController)
        
        // 3. sheet 띄우기
        if isNavigationController {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .pageSheet
            setupDynamicHeight(navigationController, hostingController, sheetHeight: sheetHeight, detentIdentifier: detentIdentifier)
            self.present(navigationController, animated: animated, completion: completion)
        } else {
            viewController.modalPresentationStyle = .pageSheet
            setupDynamicHeight(viewController, hostingController, sheetHeight: sheetHeight, detentIdentifier: detentIdentifier)
            self.present(viewController, animated: animated, completion: completion)
        }
    }
    
    /// `UIHostingController`를 직접 전달받아 동적으로 높이가 조정되는 커스텀 시트를 생성하는 함수
    /// 원하는 배경 뷰와 내용 뷰를 지정하고, 고정된 높이도 지정할 수 있다.
    func presentCustomSheet<Content: View>(
        _ hostingController: UIHostingController<Content>,
        backgroundView: UIView? = nil,
        sheetHeight: CGFloat? = nil,
        detentIdentifier: String = "fixedHeight",
        animated: Bool = true,
        isNavigationController: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        // 1. UIViewController 생성
        let viewController = setupBackgroundViewController(with: backgroundView)
        
        // 2. 뷰컨트롤러에 Hosting Controller 추가
        setupHostingController(viewController, hostingController)
        
        // 3. sheet 띄우기
        if isNavigationController {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .pageSheet
            setupDynamicHeight(navigationController, hostingController, sheetHeight: sheetHeight, detentIdentifier: detentIdentifier)
            self.present(navigationController, animated: animated, completion: completion)
        } else {
            viewController.modalPresentationStyle = .pageSheet
            setupDynamicHeight(viewController, hostingController, sheetHeight: sheetHeight, detentIdentifier: detentIdentifier)
            self.present(viewController, animated: animated, completion: completion)
        }
    }
    
    // MARK: - Private methods
    
    private func setupBackgroundViewController(
        _ viewController: UIViewController? = nil,
        with backgroundView: UIView? = nil
    ) -> UIViewController {
        let viewController = viewController ?? UIViewController()
        if let backgroundView = backgroundView {
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            viewController.view.addSubview(backgroundView)
            NSLayoutConstraint.activate([
                backgroundView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
            ])
        } else {
            viewController.view.addGradientBackground()
        }
        return viewController
    }
    
    private func setupHostingController<Content: View>(
        _ viewController: UIViewController,
        _ hostingController: UIHostingController<Content>
    ) {
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        viewController.addChild(hostingController)
        viewController.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: viewController)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
    }
    
    /// 동적 높이 지정
    private func setupDynamicHeight<Content: View>(
        _ viewController: UIViewController,
        _ hostingController: UIHostingController<Content>,
        sheetHeight: CGFloat? = nil,
        detentIdentifier: String = "fixedHeight"
    ) {
        if let sheet = viewController.sheetPresentationController {
            hostingController.view.layoutIfNeeded()
            let calculatedHeight = hostingController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            let finalHeight = sheetHeight ?? calculatedHeight

            let fixedDetent = UISheetPresentationController.Detent.custom(
                identifier: UISheetPresentationController.Detent.Identifier(detentIdentifier)
            ) { _ in
                return finalHeight
            }

            sheet.detents = [fixedDetent]
            sheet.prefersGrabberVisible = true
        }
    }
}
