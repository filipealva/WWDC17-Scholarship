//
//  DotsViewController.swift
//  Filipe Alvarenga
//
//  Created by Filipe Alvarenga on 26/03/17.
//  Copyright (c) 2015 Filipe Alvarenga. All rights reserved.
//

import UIKit
import SafariServices

// Tricky but needed since Playgrounds can't deal with 'weak' references. They just don't work :( so I made this subclass that has a strong delegate proxy.
// Creativity++ on my avaliation, huh? :P
public class StrongDelegateScrollView: UIScrollView {
    
    public var strongDelegate: UIScrollViewDelegate? {
        didSet {
            self.delegate = strongDelegate
        }
    }
    
}

public class DotsViewController: UIViewController {

    // MARK: - Properties

    lazy var baseScrollView: StrongDelegateScrollView = StrongDelegateScrollView()
    lazy var bottomBar: UIButton = UIButton()
    
    
    var needsDisplayIntro = true
    let frameToDisplay = CGRect(x: 0, y: 0, width: 500, height: 500)
    
    lazy var greetingsView: UIView = {
       let greetingsView =  Bundle.main.loadNibNamed("GreetingsView", owner: self, options: nil)![0] as! UIView
       greetingsView.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: self.frameToDisplay.size)
       
       return greetingsView
    }()
    
    lazy var line: UIView = { [unowned self] in
        let firstDotView = self.dotViews.first!
        let firstDot = firstDotView.dot
        firstDot.layoutIfNeeded()

        let line = UIView(frame: CGRect(x: firstDotView.dot.center.x - 1.5, y: self.view.bounds.height * 1.5, width: 3.0, height: 0.0))
        line.backgroundColor = UIColor.black
        line.layer.cornerRadius = 2.0
        
        return line
    }()
    
    lazy var dotViews: [UIView] = {
        self.stories.enumerated().map() { (index, story) in
            let dotView = Bundle.main.loadNibNamed("DotView", owner: self, options: nil)![0] as! UIView
            let dotViewFrame = CGRect(x: 0.0, y: self.frameToDisplay.size.height * CGFloat(index + 1), width: self.frameToDisplay.size.width, height: self.frameToDisplay.size.height)
            dotView.frame = dotViewFrame
            self.configure(story: story, onDotView: dotView)
            
            return dotView
        }
    }()
    
    lazy var stories: [Story] = {
        let pathToAboutMe = Bundle.main.path(forResource: "AboutMe", ofType: "plist")!
        let aboutMe = NSDictionary(contentsOfFile: pathToAboutMe) as! [String: AnyObject]
        let stories = aboutMe["stories"] as! [[String: AnyObject]]
        
        return stories.map({Story(dict: $0)})
    }()
    
    var currentPage: Int = 0 {
        willSet(newValue) {
            switch newValue {
            case 0:
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.bottomBar.alpha = 0
                    self.greetingsView.arrowView.alpha = 1
                })
            case 1:
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.greetingsView.arrowView.alpha = 0
                })
            case stories.count:
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.bottomBar.alpha = 0.96
                })
            default:
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.bottomBar.alpha = 0
                })
            }
        }
    }
    
    // MARK: - Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let tapToScrollDown = UITapGestureRecognizer(target: self, action: #selector(DotsViewController.scrollToFirstDot))
        greetingsView.arrowView.addGestureRecognizer(tapToScrollDown)
        
        bottomBar.alpha = 0
        bottomBar.addTarget(self, action: #selector(DotsViewController.showAboutMe), for: .touchUpInside)
    }
    
    override public func loadView() {
        let rootView = UIView(frame: self.frameToDisplay)
        rootView.backgroundColor = UIColor.white
        baseScrollView.frame = rootView.frame
        baseScrollView.backgroundColor = .clear
        baseScrollView.isPagingEnabled = true
        baseScrollView.showsVerticalScrollIndicator = false
        baseScrollView.showsHorizontalScrollIndicator = false
        baseScrollView.strongDelegate = self
        rootView.addSubview(baseScrollView)
        
        bottomBar.backgroundColor = .black
        let attributedTitle = NSAttributedString(string: "About Me", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor.white])
        bottomBar.setAttributedTitle(attributedTitle, for: .normal)
        bottomBar.frame = CGRect(x: 0, y: frameToDisplay.height - 50, width: frameToDisplay.size.width, height: 50)
        rootView.addSubview(bottomBar)
        
        view = rootView
        addDotsToView()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if needsDisplayIntro {
            showStartViewController()
        }
    }
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Views Configuration
    
    func addDotsToView() {
        baseScrollView.addSubview(greetingsView)
    
        for dotView in dotViews {
            baseScrollView.addSubview(dotView)
        }
        
        baseScrollView.addSubview(line)
        baseScrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height * CGFloat(dotViews.count + 1))
    }
    
    func configure(story: Story, onDotView dotView: UIView) {
        dotView.dot.layer.cornerRadius = dotView.dot.bounds.height / 2
        dotView.storyTitle.text = story.title
        dotView.storyDescription.text = story.description
        dotView.storyDate.text = story.date
    }
    
    // MARK: - Navigation
    
    func showStartViewController() {
        let startViewController = StartViewController()
        startViewController.setNeedsDisplayIntro = { [unowned self] in
            self.needsDisplayIntro = false
        }
        
        present(startViewController, animated: false, completion: nil)
    }
    
    func showAboutMe() {
        let aboutMe = AboutMeTableViewController()
        let nav = UINavigationController(rootViewController: aboutMe)
        
        present(nav, animated: true)
    }

}

extension DotsViewController: UIScrollViewDelegate {

    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let yOffsetMin: CGFloat = view.bounds.height
        let yOffsetMax = self.view.bounds.height * CGFloat(dotViews.count)
        
        if yOffset > yOffsetMin && yOffset < yOffsetMax {
            let yOffsetWithoutGreetingsView = yOffset - greetingsView.frame.size.height
            updateLineFrameBasedOnOffset(yOffset: yOffsetWithoutGreetingsView)
        }
        
        let fractionalPage = yOffset / view.bounds.height
        currentPage = lroundf(Float(fractionalPage))
    }
    
    // MARK: - Scroll Effects Helpers
    
    func updateLineFrameBasedOnOffset(yOffset: CGFloat) {
        var newFrame = line.frame
        newFrame.size = CGSize(width: newFrame.size.width, height: yOffset)
            
        UIView.animate(withDuration: 0.5, animations: { [unowned self] () -> Void in
            self.line.frame = newFrame
        })
    }
    
    func scrollToFirstDot() {
        baseScrollView.setContentOffset(CGPoint(x: 0.0, y: view.bounds.height), animated: true)
    }
    
}

extension DotsViewController: SFSafariViewControllerDelegate {
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
