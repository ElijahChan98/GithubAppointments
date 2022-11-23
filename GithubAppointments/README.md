# GithubAppointments

This app will display a list of GitHub Users which the user can select and book appointments with

List of missing features to be added if given more time:

Data Persistence - Integration of CoreData for offline use and image caching. CoreData inserts will be done after fetching, and when no internet is detected, the app will display the list of cached users but will not allow scheduling of appointments

Unit and UI Testing - Test Persistence layer, test different environments, test functions with return statements

Environment Configurations - Debug and staging should not successfully book appointments but rather mock the success and failure. All time frames will be available on dev environments, while staging and production will show real time frames the GitHub User is available

Additional Implementations - Show a collectionview of cards where you can see the past and future events the GitHub User has attended/will attend.

Fail States - App will react accordingly to fail states on API fetching

Pagination - The app currently only shows the default limit of Github users (30). Prefetching will be added to the tableview to enable pagination

Test Plan:
- To test if the size of the returned GitHub users: Create test for the fetch users endpoint and assert that the returned users are more than 0.
- To test that the returned users list are valid: Create test that will assert that the returned user list are compatible with the object GithubUser and are readable by the table view
- To test if the details of the mentor is complete: Create test that will assert that the fetched profile of this user is compatible with the object GithubUser and all required fields are populated
- To test if the slots are available to book with the mentor: Create test that will check the mentor's schedule returned by the API (if API supplies this) and assert that once a schedule is booked, the API will reflect these changes and will no longer return an availabilty on the booked date
