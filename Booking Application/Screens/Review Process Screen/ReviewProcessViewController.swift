//
//  ReviewProcessViewController.swift
//  Booking Application
//
//  Created by student on 12.05.21.
//

import SwiftUI

class ReviewProcessViewController: UIHostingController<ReviewProcessView>  {
    private let viewModel: ReviewProcessViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: -> Update Values
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    // MARK: -> Make Navigation Bar Hidden
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: -> Initialization SwiftUI View
    
    init(placeIdentifier: Int) {
        viewModel = ReviewProcessViewModel(placeIdentifier: placeIdentifier)
        let view = ReviewProcessView(viewModel: viewModel)
        super.init(rootView: view)
        viewModel.controller = self
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Click On 'Back' Button
    
    func redirectPrevious() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}


//// Put this piece of code anywhere you like
//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}

//extension UIHostingController {
//    convenience public init(rootView: Content, ignoreSafeArea: Bool) {
//        self.init(rootView: rootView)
//
//        if ignoreSafeArea {
//            disableSafeArea()
//        }
//    }
//
//    func disableSafeArea() {
//        guard let viewClass = object_getClass(view) else { return }
//
//        let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoreSafeArea")
//        if let viewSubclass = NSClassFromString(viewSubclassName) {
//            object_setClass(view, viewSubclass)
//        }
//        else {
//            guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
//            guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }
//
//            if let method = class_getInstanceMethod(UIView.self, #selector(getter: UIView.safeAreaInsets)) {
//                let safeAreaInsets: @convention(block) (AnyObject) -> UIEdgeInsets = { _ in
//                    return .zero
//                }
//                class_addMethod(viewSubclass, #selector(getter: UIView.safeAreaInsets), imp_implementationWithBlock(safeAreaInsets), method_getTypeEncoding(method))
//            }
//
//            if let method2 = class_getInstanceMethod(viewClass, NSSelectorFromString("keyboardWillShowWithNotification:")) {
//                let keyboardWillShow: @convention(block) (AnyObject, AnyObject) -> Void = { _, _ in }
//                class_addMethod(viewSubclass, NSSelectorFromString("keyboardWillShowWithNotification:"), imp_implementationWithBlock(keyboardWillShow), method_getTypeEncoding(method2))
//            }
//
//            objc_registerClassPair(viewSubclass)
//            object_setClass(view, viewSubclass)
//        }
//    }
//}
