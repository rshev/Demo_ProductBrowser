# Example_ProductBrowser

The test project for the one of the UK's biggest online retail companies.

#### Project highlights

* Swift 2.2 + RxSwift technology stack, MVVM architecture
* All auto-layout (try rotating to landscape at **any** screen, try 4S)
* Weak references where appropriate, no strong reference cycles at all **(definitely try profiling it)**
* Paged ScrollView on product details screen auto-adjusts content offset to be on the same page when device is rotated **(try rotating it there with different product images on screen)**. Also, this paged ScrollView built with ImageViews with constraints in code after getting images from the Backend (making it independent of images count).
* Product Details screen has "Add to Bag" button pinned to the bottom of the screen if the screen is big enough, but if the screen is small (4S), the button is scrolled with the whole screen. Made with zero lines of code, only with auto-layout constraints. **(definitely try it)**
* Uses Moya+Alamofire for Backend access with custom RxSwift extension to re-try failed network requests automatically. Asynchronous image download with in-memory cache.
* Helper for shopping bag bar button draws item count off-screen and replaces bar button for a View Controller it manages.
* Using R.swift for statically typed resources (images, storyboards, segues etc)
* Tests
* Generally, a lot of comments in code

#### License

MIT
