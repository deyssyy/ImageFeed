@testable import ImageFeed
import XCTest

final class ImageListTests: XCTestCase {
    
    func testViewDidLoadIsCalled(){
        let vc = ImageFeed.ImagesListViewController()
        let presenter = ImageListPresenterSpy()
        
        vc.presenter = presenter
        presenter.view = vc
        
        _ = vc.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testFetch(){
        let vc = ImageListViewControllerSpy()
        let mockService = mockImageListService()
        let presenter = ImageListPresenter(imageListService: mockService)
        
        presenter.view = vc
        vc.presenter = presenter
        
        presenter.fetchPhotosNextPage()
        
        XCTAssertTrue(mockService.fetchPhotosNextPageCalled)
    }
    
    func testUpdatePhotoCountTriggersUpdateTableViewAnimated(){
        let vc = ImageListViewControllerSpy()
        let mockService = mockImageListService()
        let presenter = ImageListPresenter(imageListService: mockService)
        
        presenter.view = vc
        vc.presenter = presenter
        
        let photo = Photo(id: "", size: CGSize(width: 1, height: 1), createdAt: nil, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: true)
        let photo1 = Photo(id: "", size: CGSize(width: 1, height: 1), createdAt: nil, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: true)
        let photo2 = Photo(id: "", size: CGSize(width: 1, height: 1), createdAt: nil, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: true)
        mockService.photos.append(contentsOf: [photo, photo1, photo2])
        
        presenter.updatePhotoCount()
        
        XCTAssertTrue(vc.updateTableViewAnimatedCalled)
        XCTAssertEqual(presenter.getPhotosCount(), 3)
    }
    
    func testChangeLikeTriggersSetLike(){
        let vc = ImageListViewControllerSpy()
        let mockService = mockImageListService()
        let presenter = ImageListPresenter(imageListService: mockService)
        let initialIsLikedState = true
        
        presenter.view = vc
        vc.presenter = presenter
        
        let photo = Photo(id: "test", size: CGSize(width: 1, height: 1), createdAt: nil, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: initialIsLikedState)
        mockService.photos.append(photo)
        presenter.updatePhotoCount()
        let indexPath = IndexPath(row: 0, section: 0)
        
        let changeLikeExcpectation = expectation(description: "ChangeLikeExcpectation")
        
        presenter.changeLike(at: indexPath)
        
        XCTAssertTrue(mockService.changeLikeCalled, "changeLike должен вызвать сервис")
        XCTAssertTrue(vc.setLikeCalled)
        
        let updatedPhoto = presenter.getPhoto(at: indexPath)
        XCTAssertEqual(updatedPhoto.isLiked, !initialIsLikedState)
        
        let updatedServicePhoto = mockService.photos.first!
        XCTAssertEqual(updatedServicePhoto.isLiked, !initialIsLikedState)
        
        changeLikeExcpectation.fulfill()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testGetPhotoCount(){
        let vc = ImageListViewControllerSpy()
        let mockService = mockImageListService()
        let presenter = ImageListPresenter(imageListService: mockService)
        
        presenter.view = vc
        vc.presenter = presenter
        
        let photo = Photo(id: "test", size: CGSize(width: 1, height: 1), createdAt: nil, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: true)
        mockService.photos.append(photo)
        presenter.updatePhotoCount()
        
        XCTAssertEqual(presenter.getPhotosCount(), 1)
    }
    
    func testGetPhotoatIndex(){
        let vc = ImageListViewControllerSpy()
        let mockService = mockImageListService()
        let presenter = ImageListPresenter(imageListService: mockService)
        
        presenter.view = vc
        vc.presenter = presenter
        
        let photo = Photo(id: "test", size: CGSize(width: 1, height: 1), createdAt: nil, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: true)
        mockService.photos.append(photo)
        presenter.updatePhotoCount()
        
        let funcPhoto = presenter.getPhoto(at: IndexPath(row: 0, section: 0))
    
        XCTAssertNotNil(funcPhoto)
        XCTAssertEqual(funcPhoto.id, "test")
    }
    
    func testResetStateForLogout() {
        let vc = ImageListViewControllerSpy()
        let mockService = mockImageListService()
        let presenter = ImageListPresenter(imageListService: mockService)
        
        presenter.view = vc
        vc.presenter = presenter
        
        let photo = Photo(id: "test", size: CGSize(width: 1, height: 1), createdAt: nil, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: true)
        mockService.photos.append(photo)
        presenter.updatePhotoCount()
        
        presenter.resetStateForLogout()
        
        XCTAssertEqual(presenter.getPhotosCount(), 0)
    }
}
