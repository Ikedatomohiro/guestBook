//
//  GuestCardViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/04.
//

import UIKit
import PencilKit

class GuestCardViewController: UIViewController {

    fileprivate let cardTitleLabel = UILabel()
    fileprivate let selectRitualLabel = UILabel()
    fileprivate let retualArray:[String] = ["通夜", "告別式"]
    fileprivate let guestNameLabel = UILabel()
    fileprivate let companyNameLabel = UILabel()
    fileprivate let zipCodeLabel = UILabel()
    fileprivate let telLabel = UILabel()
    fileprivate let addressLabel = UILabel()
    fileprivate let selectAcuaintanceQuestionLabel = UILabel()
    fileprivate let selectAcuaintanceLabel = UILabel()
    fileprivate let selectRelationQuestionLabel = UILabel()
    fileprivate let selectRelationLabel = UILabel()

    
    fileprivate var pageviewController: UIPageViewController!
    fileprivate var controllers: [UIViewController] = []
    private var pageControl: UIPageControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initPageViewController()
        

    }
    
    fileprivate func setupLabels() {
        view.addSubview(cardTitleLabel)
        cardTitleLabel.text = "ご芳名カード"
        
        
        view.addSubview(selectRitualLabel)
        
        
        
        view.addSubview(guestNameLabel)
        
        
        
        view.addSubview(companyNameLabel)
        
        
        
        view.addSubview(zipCodeLabel)
        
        
        
        view.addSubview(telLabel)
        
        
        
        view.addSubview(addressLabel)
        view.addSubview(selectAcuaintanceQuestionLabel)
        view.addSubview(selectAcuaintanceLabel)
        view.addSubview(selectRelationQuestionLabel)
        view.addSubview(selectRelationLabel)
        
        
        
        
    }
    
    fileprivate func initPageViewController() {

        // 描画ツールのセット
        setCanvas()

        let backColor: [ UIColor ] = [ .systemIndigo, .systemOrange, .systemGreen ]

        for i in 0 ... 2 {
            let myViewController: UIViewController = UIViewController()
            myViewController.view.backgroundColor = backColor[i]
            myViewController.view.frame = self.view.frame
            self.controllers.append(myViewController)
        }
        self.pageviewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        // self.controllers[0]に変数を入れて任意のページをスタートにする
        self.pageviewController.setViewControllers([self.controllers[0]], direction: .forward, animated: true, completion: nil)
        self.pageviewController.dataSource = self
        
        self.addChild(self.pageviewController)
        self.view.addSubview(self.pageviewController.view!)
        
    }

    
    fileprivate func setCanvas() {
        let canvas = PKCanvasView(frame: view.frame)
        view.addSubview(canvas)
        canvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        
        // PKToolPicker: ドラッグして移動できるツールパレット (ペンや色などを選択できるツール)
        if let window = UIApplication.shared.windows.first {
            if let toolPicker = PKToolPicker.shared(for: window) {
                toolPicker.addObserver(canvas)
                toolPicker.setVisible(true, forFirstResponder: canvas)
                canvas.becomeFirstResponder()
            }
        }
    }
}
extension GuestCardViewController: UIPageViewControllerDataSource {
    // ページ数
    func guestCardCount(for pageViewController: UIPageViewController) -> Int {
        return self.controllers.count
    }

    // 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.controllers.firstIndex(of: viewController),
            index < self.controllers.count - 1 {
            return self.controllers[index + 1]
        } else {
            return nil
        }
    }
    
    // 右にスワイプ（戻る）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.controllers.firstIndex(of: viewController),
            index > 0 {
            return self.controllers[index - 1]
        } else {
            return nil
        }
    }
}

extension GuestCardViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPage = pageViewController.viewControllers![0]
        self.pageControl.currentPage = self.controllers.firstIndex(of: currentPage)!

    }

}
