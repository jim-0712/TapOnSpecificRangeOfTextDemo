//
//  CustomMultiTouchLabel.swift
//  TapOnSpecificRangeOfTextDemo
//
//  Created by Fu Jim on 2021/3/15.
//

import UIKit

class CustomMultiTouchLabel: UILabel {
    
    var textStorage: NSTextStorage {
        get {
            let textAttribute: NSMutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText!)
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            textAttribute.addAttributes([NSAttributedString.Key.font: font as Any,
                                         NSAttributedString.Key.paragraphStyle: paragraphStyle],
                                        range: NSRange(location: 0,
                                                       length: textAttribute.length))
            return NSTextStorage(attributedString: textAttribute)
        }
    }
    
    var textContainer: NSTextContainer {
        get {
            let container = NSTextContainer(size: frame.size)
            container.lineFragmentPadding = 0.0
            container.lineBreakMode = lineBreakMode
            container.maximumNumberOfLines = numberOfLines
            return container
        }
    }
    
    var observeString = [String: String]()
    var requireUpdateLineBreaking: Bool = false
    var keyWord = String()
    
    public
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    public
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal
    func setup() {
        requireUpdateLineBreaking = true
        isUserInteractionEnabled = true
        numberOfLines = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }
    
    @objc internal
    func handleTap(_ sender: UITapGestureRecognizer) {
        guard let texts = text else { return }
        let tapLoaction = sender.location(in: self)
        
        let storage = self.textStorage
        let layoutManager = NSLayoutManager()
        storage.addLayoutManager(layoutManager)
        let textContain = self.textContainer
        layoutManager.addTextContainer(textContain)
        
        let tapIndex = layoutManager.characterIndex(for: tapLoaction,
                                                    in: textContain,
                                                    fractionOfDistanceBetweenInsertionPoints: nil)
        
        var ranges = [NSRange]()
        observeString.forEach { key, value in
            ranges.append((texts as NSString).range(of: key))
        }
        
        for range in ranges where NSLocationInRange(tapIndex, range) {
            if let texts = text,
               let convertRange = Range(range, in: texts),
               let word = observeString[String(texts[convertRange])] {
                keyWord = word
            }
        }
    }
    
    func lineBreakIfNeeded() -> Void {
        if requireUpdateLineBreaking {
            numberOfLines += 1
            let textStorage = self.textStorage
            let layoutManager = NSLayoutManager()
            textStorage.addLayoutManager(layoutManager)
            
            layoutManager.addTextContainer(self.textContainer)
            let numberOfGlyphs = layoutManager.numberOfGlyphs
            var lineRange: NSRange = NSRange(), previousSeparatorRange: Range = Range(NSRange(location: 0, length: 0), in: textStorage.string)!
            var update = false
            for var index in 0..<numberOfGlyphs {
                layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
                index = NSMaxRange(lineRange)
                if textStorage.length > index {
                    guard let stringRange = Range(NSRange(location: index, length: 1), in: textStorage.string) else {
                        return
                    }
                   
                    let compareString = String(textStorage.string[stringRange])
                    if compareString != "\n" {
//                        let separatorRange = textStorage.string.range(of: textStorage.string[Range(NSRange(location: index, length: 1), in: textStorage.string)!],
//                                                                      options: String.CompareOptions.backwards,
//                                                                      range: Range(NSRange(location: 0, length: index),
//                                                                                   in: textStorage.string),
//                                                                      locale: nil)
                        let separatorRange = Range(NSRange(location: index-1, length: 1), in: textStorage.string)
                        if separatorRange?.lowerBound != previousSeparatorRange.lowerBound {
                            update = true
                            let range = NSRange(separatorRange!, in: textStorage.string)
                            textStorage.insert(NSAttributedString(string: "\n"), at: range.location-1 + range.length)
                            numberOfLines += 1
                            previousSeparatorRange = separatorRange!
                        }
                    }
                }
            }
            requireUpdateLineBreaking = false
            if update {
                super.attributedText = textStorage
            }
        }
    }
    override open func layoutSubviews() -> Void {
        super.layoutSubviews()
        lineBreakIfNeeded()
    }
    
    override open var attributedText: NSAttributedString? {
        didSet {
            requireUpdateLineBreaking = true
        }
    }
}
