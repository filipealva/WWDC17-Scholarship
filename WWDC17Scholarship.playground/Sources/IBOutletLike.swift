import Foundation
import UIKit

protocol IBOutletLike {
    
    // DotView outlets
    var storyTitle: UILabel { get }
    var storyDescription: UILabel { get }
    var storyDate: UILabel { get }
    var dot: UIView { get }
    var storyContainer: UIView { get }
    var storyContainerHeightConstraint: NSLayoutConstraint { get }
    
    // GreetingsView outlets
    var arrowView: UIView { get }
    
    
    // StartView outlets
    var startButton: UIButton { get }
    
}

extension UIView: IBOutletLike {
    
    public var storyTitle: UILabel {
        get {
            return viewWithTag(100) as! UILabel
        }
    }
    
    public var storyDescription: UILabel {
        get {
            return viewWithTag(300) as! UILabel
        }
    }
    
    public var storyDate: UILabel {
        get {
            return viewWithTag(200) as! UILabel
        }
    }
    
    public var dot: UIView {
        get {
            return viewWithTag(400)!
        }
    }
    
    public var storyContainer: UIView {
        get {
            return viewWithTag(500)!
        }
    }
    
    public var storyContainerHeightConstraint: NSLayoutConstraint {
        get {
            return self.constraints.filter({$0.identifier == "storyContainerHeight"}).first!
        }
    }
    
    public var arrowView: UIView {
        get {
            return viewWithTag(700)!
        }
    }
    
    public var startButton: UIButton {
        get {
            return viewWithTag(800) as! UIButton
        }
    }
    
}
