//
//  CustomLabelViewController.swift
//  TapOnSpecificRangeOfTextDemo
//
//  Created by Fu Jim on 2021/3/15.
//

import UIKit

class CustomLabelViewController: UIViewController {
    
    let containView: UIView = {
        let contain = UIView()
        contain.backgroundColor = .orange
        contain.translatesAutoresizingMaskIntoConstraints = false
        return contain
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var heightConstraints = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var heightAndRows: (CGFloat, Int) = (0,0)
        stackView.subviews.forEach { view in
            if let label = view as? CustomMultiTouchLabel {
                heightAndRows.1 += label.numberOfLines
                heightAndRows.0 = label.attributedText?.size().height ?? 0.0
            }
        }
        heightConstraints.constant = heightAndRows.0 * CGFloat(heightAndRows.1)
    }
    
    internal
    func setupView() {
        heightConstraints = containView.heightAnchor.constraint(equalToConstant: 0)
        view.addSubview(containView)
        NSLayoutConstraint.activate([
            containView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containView.widthAnchor.constraint(equalToConstant: 200),
            heightConstraints
        ])
        
        containView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containView.bottomAnchor)
        ])
        
        setupStackViewContent()
    }
    
    internal
    func setupStackViewContent() {
        demo1.enumerated().forEach { index, people in
            if let shapes = people.bodyShape, !shapes.isEmpty {
                shapes.forEach { shape in
                    handleText(people: people.name, shape: shape, index: index)
                }
            } else {
                createLabel(text: people.name, index: index)
            }
        }
    }
    
    internal
    func handleText(people: String, shape: BodyShape, index: Int){
        var text = people
        text.append("+\(shape.height)&&\(shape.weight)")
        createLabel(text: text, index: index)
    }
    
    internal
    func createLabel(text: String, index: Int){
        let textAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let attributeString = NSAttributedString(string: text, attributes: textAttribute)

        let label = CustomMultiTouchLabel()
        label.tag = index
        label.lineBreakMode = .byCharWrapping
        label.attributedText = attributeString
        label.isUserInteractionEnabled = true
        
        stackView.addArrangedSubview(label)
    }
    
    
}
