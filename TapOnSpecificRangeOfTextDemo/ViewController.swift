//
//  ViewController.swift
//  TapOnSpecificRangeOfTextDemo
//
//  Created by Fu Jim on 2021/3/15.
//

import UIKit

class ViewController: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    internal
    func setupView() {
        view.addSubview(containView)
        NSLayoutConstraint.activate([
            containView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containView.widthAnchor.constraint(equalToConstant: 200)
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
        var height = CGFloat(0)
        demo1.enumerated().forEach { index, people in
            if let shapes = people.bodyShape, !shapes.isEmpty {
                shapes.forEach { shape in
                    height += handleText(people: people.name, shape: shape, index: index)
                }
            } else {
                height += createLabel(text: people.name, index: index)
            }
        }
        containView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    internal
    func handleText(people: String, shape: BodyShape, index: Int) -> CGFloat {
        var text = people
        text.append(" + \(shape.height)&&\(shape.weight)")
        return createLabel(text: text, index: index)
    }
    
    internal
    func createLabel(text: String, index: Int) -> CGFloat{
        let textAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let attributeString = NSAttributedString(string: text, attributes: textAttribute)
        let attributeStringWidth = attributeString.size().width
        
        let label = UILabel()
        label.tag = index
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = attributeStringWidth > stackView.frame.size.width ? 2 : 1
        label.attributedText = attributeString
        label.isUserInteractionEnabled = true
        
        // setup Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnLabel(_:)))
        label.addGestureRecognizer(tapGesture)
        
        stackView.addArrangedSubview(label)
        return attributeString.size().height * (attributeStringWidth > 200 ? 2 : 1)
    }
    
    
    @objc internal
    func tapOnLabel(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag,
              let label = sender.view as? UILabel,
              let texts = label.text,
              stackView.arrangedSubviews.count >= tag else {
            return
        }
        var ranges = [NSRange]()
        let components = texts.components(separatedBy: "+")
        components.forEach { text in
            ranges.append((texts as NSString).range(of: text))
        }
        
        for range in ranges where sender.didTapAttributedTextInLabel(label: label, inRange: range) {
            if let convertRange = Range(range, in: texts) {
                print(String(texts[convertRange]))
            }
            break
        }
    }
}

