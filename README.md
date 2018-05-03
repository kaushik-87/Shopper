# Shopper
# Browse products


iOS application  
Swift 4.1 and Xcode 9.3. 

This project demonstrates the iOS application which fetches the products list from Walmart API.
Used much cleaner architechture **MVVM + Coordinator**. This design helps in keeping the view controller thin. 
Coordinators help in controlling the flow of the application screens. 

This demo project also demonstrates the **protocol oreinted programming** for Network communication layer. 
This approach helps in testing with mock network layer. 

Time spent: Around 30+ hours spent in total

Completed user stories:

 * [x] Required: 
 
 Screen 1:
The first screen should contain a list of all the products returned by the service call.
The list should support lazy loading. When you scroll to the bottom of the list, start lazy loading next page of products and append it to the list
 
Screen 2:
The second screen should display details of the product.
 
* [x] Bonuses:

Ability to swipe to view next/previous item ( Eg: Gmail app)
Autolayout.
 
The following **additional** features are implemented:
 
 * [x] Optional: Reusable Network layer which supports different environment (QA, PROD etc)
 * [x] Optional: Pull to refresh.
 * [x] Optional: Used collection view, in case we need to change the layout in future.
 * [x] Optional: Demonstrated mocking of the network layer in unit tests.
 
 
 Here's a walkthrough of implemented user stories:

<img src='https://i.imgur.com/8CGK5gP.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).
