# Do cats love RAM?

Get the full power of UIKit collections for your SwiftUI projects!

> **Important:** I need help to improve this project! Сode review or implementing sui tricks to improve performance will be very helpful

### Performance (Apple A12)
* GeometryReader in each cell + medium resolution pictures

![Project demo](screenrecording.gif)

* Using NukeUI, with old conditions

![Project demo NukeUI](screenrecordingNukeUI.gif)

### Get the full power of UIKit collections for your projects!
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
.onReceive(loadMore) {
    //fetch next page
}
.onReceive(pullToRefresh) {
    //refreshing page
}
```

Or just as a replacement SwiftUI ForEach
```swift
UIKitCollection(items: catsDB) { indexPath, item in
    NavigationLink(destination: CatsFavoriteDetail(cat: item)) {
        AsyncImageCached(url: item.url) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
    }
}
```
