# Walmart_App
App:
-It accepts users product search string and display the results of the search.
-On clicking particular product for details, it displays the details of the product along with the recommended products based on his selected product.

Technical:
1. UITableView:
Used UITableView for displaying the search results of the product string.
Used Custom TableView Cell to display basic details of product in table.

2. Containers:
Used two containers in details page, one for displaying product details and another for displaying recommendations

3. UICollectionView
Used UICollectionView to display the list of recommended products in the details page.
The list of products will be displayed n horizontal position.

User Interface( Used Both Storyboard and Program):
Used StoryBoard for the first tableview.
Created UI via program for the details view.

Design Pattern:
App is developed by following MVC architecture.

App Flow-Testing steps
1. App will have launch screen which will be displayed until the app is loaded
2. After loading, User can search his products by entering his search string in the search bar
3. On clicking enter, a list of items based on his search string will e displayed as table.
4. User can either click on image or product name to know more details about the product.
5. On clicking, user can view the details of the product in the next page, along with the recommended products based on his product. The recommended products will be displayed at the bottom of the page

Additional points:
1. User can see the details of a product only on clicking its image or product name - as mentioned in the requirement.
