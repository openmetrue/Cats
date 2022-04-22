# Cats
SwiftUI + UICollectionView (with reusable SwiftUI Cell) + Combine + CoreData + ImageCache (thanks to Vadim @V8tr)

### Performance

![Project demo](screenrecording.gif)

You can use a collection with pagination, with pullToRefresh
```swift
public let pullToRefresh = PassthroughSubject<Void, Never>()
public let loadMore = PassthroughSubject<Void, Never>()
public let limit = 10
UIKitCollection(items: cats,
                prefetchLimit: limit,
                loadMoreSubject: loadMore,
                pullToRefreshSubject: pullToRefresh)
{ indexPath, item in
    CatsCell(item: item, index: indexPath.row)
}
.onReceive(viewModel.loadMoreSubject) {
    //fetch next page
}
.onReceive(viewModel.pullToRefreshSubject) {
    //refreshing page
}
```

Or just as a replacement SwiftUI ForEach!
```swift
UIKitCollection(items: catsDB) { indexPath, item in
    NavigationLink(destination: CatsFavoriteDetail(cat: item)) {
        AsyncImageCached(url: item.url) { image in
            image.centerCropped()
        } placeholder: {
            ProgressView()
        }
    }
}
```

> **Important:** I need help to improve this project, now I have problems with cordata and many other things
