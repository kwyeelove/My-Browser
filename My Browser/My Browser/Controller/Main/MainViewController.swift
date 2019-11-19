//
//  MainViewController.swift
//  My browser
//
//  Created by Kiwon on 17/09/2019.
//  Copyright © 2019 Sidory. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

protocol MainViewControllerDelegate {
    func showSearchBar(animate: Bool)
    func hideSearchBar(animate: Bool)
}

class MainViewController: BaseViewController {
    
    /// Tabbar Title의 양쪽 여백 (좌우 여백의 합 값)
    let SECTION_TITLE_MARGIN: CGFloat = 10 * 2
    /// Tabbar LineView Height
    let SECTION_LINE_HEIGHT: CGFloat = 3.0
    
    /// 상단 Tabbar CollectionView
    @IBOutlet weak var tabbarCollectionView: UICollectionView!
    /// 하단 영역 뷰 (페이지 뷰)
    @IBOutlet weak var pageView: UIView!
    /// 하단 AD 뷰
    @IBOutlet weak var adView: GADBannerView!
    
    @IBOutlet weak var adViewHeight: NSLayoutConstraint!
    
    /// 하단 Tab Bar 뷰
    var tabBar: MainTabBar!
    
    /// 하단 광고뷰
    private var bannerView: GADBannerView!
    
    /// 매장 메뉴바의 하단 Line뷰
    private var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.getColor("bed730")
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    /// UIPageViewController
    private var pageContainer: UIPageViewController!
    /// 현재 페이지 Index
    private var currentIndex: Int = 0
    ///
    private var pendingIndex: Int?
    ///
    private lazy var viewControllers: [UIViewController] = {
        var detailViewControllers = [UIViewController]()
        for item in self.tabItems {
            if let vc = UIStoryboard.init(name: Const.StoryBoard.Main.name, bundle: nil).instantiateViewController(withIdentifier: WKWebViewController.reusableIdentifier) as? WKWebViewController {
                vc.mainDelegate = self
                vc.url = item.value(forKey: Const.CoreData.Tab.url.name) as? String ?? ""
                vc.name = item.value(forKey: Const.CoreData.Tab.name.name) as? String ?? ""
                detailViewControllers.append(vc)
            }
        }
        return detailViewControllers
    }()
    /// CoreData에 저장된 Tab 목록
    private var tabItems = [NSManagedObject]()
    /// 모든 텝 제목의 Width
    private var tabTitleWidths = [CGFloat]()
    
    
    /// Search Bar
    var searchBar = UISearchBar()
    /// Search Controller
    let searchController = UISearchController(searchResultsController: nil)

    /// 구글 전면 광고
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.placeholder = Const.Text.search_bar_placeholder.localized
        searchBar.delegate = self
        
        self.view.backgroundColor = .white
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK:- Private Functions
extension MainViewController {
    
    /// UI 초기화
    private func setUI() {
        // 저장된 tab 데이터 가져오기
        if let datas = CoreDataManager.loadAllCoreData(entity: Const.CoreData.Tab.entity.name) {
            if datas.count <= 0 {
                let defaultData = Tab(context: self.context, defaultSet: true)
                CoreDataManager.saveCoreData(defaultData)
                self.tabItems = [defaultData]
            } else {
                self.tabItems = datas
            }
            self.setMenuBarViewWidth()
        }
        
        // SearchBar setup
        setupSearchBar()
        
        // 상단 CollectionView 설정
        setupCollectionView()
        
        // 라인뷰 초기화
        initLineView()
        
        // PageVC를 이용하여 Detail VC 설정
        initPageControll()
        
        // 최소 실행시 Tab은 0번째 index로 고정할꺼니깐 라인/Page도 0번째
        // page 설정
        setCurrentPage(index: 0)
        // 라인 위치 설정
        setLineView(index: 0, animate: false)
        
//        // 하단 TabBar 설정
//        initTabBar()
//
//        // 하단 광고뷰 초기화
//        initAdView()
//
//        // 전면광고 초기화
//        initInterstitial()
    }
    /// 전면광고 초기화
    private func initInterstitial() {
        // 구글 광고
        #if DEBUG
        let adUnitID = Const.Google.Popup_DEBUG.ID
        #else
        let adUnitID = Const.Google.Popup.ID
        #endif
        self.interstitial = GADInterstitial(adUnitID: adUnitID)
        
        let request = GADRequest()
        #if DEBUG
        request.testDevices = [ "2c4bfb4fb853b3d9b03c68578176d3a7" ]
        #endif
        interstitial.load(request)
        interstitial.delegate = self
    }
    
    /// 광고뷰 초기화
    private func initAdView() {
        self.adView.backgroundColor = .white
        self.adViewHeight.constant = 0.0
        
        self.bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        #if DEBUG
        self.bannerView.adUnitID = Const.Google.MainBanner_DEBUG.ID
        #else
        self.bannerView.adUnitID = Const.Google.MainBanner.ID
        #endif
        self.bannerView.rootViewController = self
        
        let request = GADRequest()
        #if DEBUG
        request.testDevices = [ "2c4bfb4fb853b3d9b03c68578176d3a7" ]
        #endif
        self.bannerView.load(request)
        self.bannerView.delegate = self
    }
    
    /// 광고뷰 설정
    private func setupAdView() {
        self.bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.adView.addSubview(self.bannerView)
        
        self.bannerView.topAnchor.constraint(equalTo: self.adView.topAnchor).isActive = true
        self.bannerView.leadingAnchor.constraint(equalTo: self.adView.leadingAnchor).isActive = true
        self.bannerView.trailingAnchor.constraint(equalTo: self.adView.trailingAnchor).isActive = true
        
        
        self.adViewHeight.constant = getSafeAreaInsets().bottom + 50.0
        self.bannerView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            self.adView.layoutIfNeeded()
        }) { (suceess) in
            UIView.animate(withDuration: 0.2) {
                self.bannerView.alpha = 1.0
            }
        }
    }
    
    /// SearchBar 설정
    private func setupSearchBar() {
        self.searchBar = self.searchController.searchBar
        self.searchBar.showsCancelButton = true
        self.searchBar.text = "왜 안되는거야~~~"
        self.searchBar.placeholder = Const.Text.search_bar_placeholder.localized
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()
        
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = Const.Text.search_bar_placeholder.localized
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.returnKeyType = .go
        self.searchController.searchBar.keyboardType = .URL
        
        self.navigationItem.titleView = self.searchController.searchBar
//        self.searchController.hidesNavigationBarDuringPresentation = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    /// Tab명에 따른 매장 MenuBarView의 width 계산
    private func setMenuBarViewWidth() {
        self.tabTitleWidths.removeAll()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        for item in self.tabItems {
            label.text = item.value(forKey: Const.CoreData.Tab.name.name) as? String
            label.sizeToFit()
            self.tabTitleWidths.append(label.intrinsicContentSize.width + SECTION_TITLE_MARGIN)
        }
    }
    
    /// 상단 매장 CollectionView 설정
    private func setupCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0.0
        collectionViewLayout.minimumInteritemSpacing = 0.0
        collectionViewLayout.scrollDirection = .horizontal
        self.tabbarCollectionView.collectionViewLayout = collectionViewLayout
        self.tabbarCollectionView.delegate = self
        self.tabbarCollectionView.dataSource = self
        self.tabbarCollectionView.backgroundColor = .white
        self.tabbarCollectionView.showsHorizontalScrollIndicator = false
        self.tabbarCollectionView.isPagingEnabled = true
        self.tabbarCollectionView.register(UINib(nibName: TabCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: TabCell.reusableIdentifier)
    }
    
    /// 라인 초기화
    private func initLineView() {
        // 매장 선택됨을 나타내는 라인뷰를 CollectionView에 Add
        self.lineView.frame = CGRect(x: 0, y: self.tabbarCollectionView.frame.height - SECTION_LINE_HEIGHT, width: 44, height: SECTION_LINE_HEIGHT)
        self.tabbarCollectionView.addSubview(self.lineView)
        
        // 라인 위치 설정 - 첫번째 매장
        self.setLineView(index: 0, animate: false)
    }
    
    /// 라인 설정
    private func setLineView(index: Int, animate: Bool = true) {
        if self.tabTitleWidths.count > index {
            self.lineView.isHidden = false
            let frame = self.lineView.frame
            var position_X: CGFloat = 0.0
            for i in 0..<index {
                position_X += self.tabTitleWidths[i]
            }
            
            if animate {
                UIView.animate(withDuration: 0.2) {
                    self.lineView.frame = CGRect(x: position_X, y: frame.origin.y, width: self.tabTitleWidths[index], height: frame.height)
                }
                return
            }
            self.lineView.frame = CGRect(x: position_X, y: frame.origin.y, width: self.tabTitleWidths[index], height: frame.height)
        } else {
            self.lineView.isHidden = true
        }
    }
    
    /// PageViewController 초기화 및 설정
    private func initPageControll() {
        self.pageContainer = UIPageViewController.init(transitionStyle: .scroll,
                                                       navigationOrientation: .horizontal,
                                                       options: nil)
        
        self.pageContainer.delegate = self
        self.pageContainer.dataSource = self
        self.pageContainer.view.backgroundColor = .white
        self.pageContainer.view.frame.size = self.pageView.frame.size
        self.pageView.backgroundColor = .white
        self.pageView.addSubview(self.pageContainer.view)
        
        // 좌우 스와이프 막기.
        for view in self.pageContainer.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.isScrollEnabled = false
            }
        }
    }
    
    /// PageViewController 현재 페이지 설정
    private func setCurrentPage(index: Int) {
        var direct: UIPageViewController.NavigationDirection = .forward
        if index < self.currentIndex {
            direct = .reverse
        }
        self.currentIndex = index
        self.pageContainer.setViewControllers([self.viewControllers[index]],
                                              direction: direct,
                                              animated: true,
                                              completion: nil)
    }
    
    /// 하단 텝바
    private func initTabBar() {
        self.tabBar = MainTabBar(frame: .zero)
        self.tabBar.delegate = self
        self.view.addSubview(self.tabBar)
    }
    
    /// Tab 추가
    private func addTabItem( _ item: NSManagedObject) {
        self.showLoading()
        self.tabItems.append(item)
        if let vc = UIStoryboard.init(name: Const.StoryBoard.Main.name, bundle: nil).instantiateViewController(withIdentifier: WKWebViewController.reusableIdentifier) as? WKWebViewController {
            vc.mainDelegate = self
            vc.url = item.value(forKey: Const.CoreData.Tab.url.name) as? String ?? ""
            vc.name = item.value(forKey: Const.CoreData.Tab.name.name) as? String ?? ""
            self.viewControllers.append(vc)
        }
        
        let currentIndex = self.tabItems.count - 1

        let destinationViewController = self.viewControllers[currentIndex]
        self.pageContainer.setViewControllers([destinationViewController], direction: .forward, animated: true) { (success) in
            self.setMenuBarViewWidth()
            UIView.animate(withDuration: 0.0, animations: {
                self.tabbarCollectionView.reloadData()
            }) { (success) in
                self.setLineView(index: currentIndex, animate: true)
                self.tabbarCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
                self.stopLoading()
            }
        }
        
    }
}

// MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCell.reusableIdentifier, for: indexPath) as? TabCell else {
            return UICollectionViewCell()
        }
        cell.titleLbl.text = self.tabItems[safe: indexPath.row]?.value(forKey: Const.CoreData.Tab.name.name) as? String ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.currentIndex == indexPath.row {
            // 나 자신을 다시 선택할 땐 무시~
            return
        }
        
        // Line 이동
        self.setLineView(index: indexPath.row)
        // 선택하면 가운데로 오도록 설정
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        var direction: UIPageViewController.NavigationDirection = .forward
        let destinationViewController = self.viewControllers[indexPath.row]
        // 현재 보여지고 있는 Page와 선택된 index에 따른 페이지 이동
        if self.currentIndex > indexPath.row {
            // 이전 페이지로 이동할 경우
            direction = .reverse
        } else {
            // 다음페이지로 이동할 경우
            direction = .forward
        }

        self.pageContainer.setViewControllers([destinationViewController], direction: direction, animated: true, completion: nil)
        self.currentIndex = indexPath.row
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.tabTitleWidths[indexPath.row], height: self.tabbarCollectionView.frame.height)
    }
}

// MARK:- Page Controll Delegate
extension MainViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.pendingIndex = self.viewControllers.firstIndex(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let pendingIdx = self.pendingIndex else { return }
            self.currentIndex = pendingIdx
            
            let selectedIndexPath = IndexPath(item: pendingIdx, section: 0)
            self.tabbarCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
            self.setLineView(index: pendingIdx)
        }
    }
}

// MARK:- Page Controll DataSource
extension MainViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex: Int = self.viewControllers.firstIndex(of: viewController) {
            if currentIndex <= 0 {
                // 제일 마지막으로 이동
                // return self.viewControllers[self.viewControllers.count - 1]
                return nil
            }
            let previousIndex = abs((currentIndex - 1) % self.viewControllers.count)
            return self.viewControllers[previousIndex]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex: Int = self.viewControllers.firstIndex(of: viewController) {
            if currentIndex >= self.viewControllers.count - 1 {
                // 제일 처음으로 이동
                // return self.viewControllers[0]
                return nil
            }
            let nextIndex = abs((currentIndex + 1) % self.viewControllers.count)
            return self.viewControllers[nextIndex]
        }
        
        return nil
    }
}

// MARK:- Button Actions
extension MainViewController {
        
}

// MARK: - UISearchBar Delegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("searchBar selectedScopeButtonIndexDidChange")
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = self.searchController.searchBar
        print("updateSearchResults")
    }
}

extension MainViewController: UISearchControllerDelegate {
    
}

// MARK:- MainTabBarDelegate
extension MainViewController: MainTabBarDelegate {
    func backBtnAction() {
        if let vc = self.viewControllers[safe: self.currentIndex] as? WKWebViewController,
            vc.wkWebView.canGoBack {
            vc.wkWebView.goBack()
        }
    }
    
    func forwardBtnAction() {
        if let vc = self.viewControllers[safe: self.currentIndex] as? WKWebViewController,
            vc.wkWebView.canGoForward {
            vc.wkWebView.goForward()
        }
    }
    
    func refreshBtnAction() {
        if let vc = self.viewControllers[safe: self.currentIndex] as? WKWebViewController {
            vc.wkWebView.reload()
        }
    }
    
    func urlBtnAction() {
        if self.searchController.isActive, !self.searchController.hidesNavigationBarDuringPresentation {
            self.searchController.hidesNavigationBarDuringPresentation = false
        }
    }
    
    func tabBtnAction() {
        if let tabEditVC = UIStoryboard(name: Const.StoryBoard.Main.name, bundle: nil).instantiateViewController(withIdentifier: TabEditTableViewController.reusableIdentifier) as? TabEditTableViewController {
            self.navigationController?.pushViewController(tabEditVC, animated: true)
        }
    }
    
    
}
// MARK:- GADBannerViewDelegate
extension MainViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        log("adViewDidReceiveAd")
        self.setupAdView()
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        log("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        log("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        log("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        log("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        log("adViewWillLeaveApplication")
    }
}

// MARK:- GADI
extension MainViewController: GADInterstitialDelegate {
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
        if self.interstitial.isReady {
            self.interstitial.present(fromRootViewController: self)
        }
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
}

// MARK:- MainViewController Delegate
extension MainViewController: MainViewControllerDelegate {
    func showSearchBar(animate: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animate)
    }
    
    func hideSearchBar(animate: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animate)
    }
}
