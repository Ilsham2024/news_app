import 'package:flutter/material.dart';
import 'package:new_news_app/Screen/category_news.dart';
import 'package:new_news_app/Screen/news_detail.dart';
import 'package:new_news_app/Services/services.dart';
import 'package:new_news_app/model/news_category.dart';
import '../model/new_model.dart';
import 'user_profile_screen.dart';

class NewsHomeScreen extends StatefulWidget {
  const NewsHomeScreen({super.key});

  @override
  _NewsHomeScreenState createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  List<NewsModel> articles = [];
  List<NewsModel> filteredArticles = [];
  List<CategoryModel> categories = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  String userName = 'ilsam';
  String userEmail = 'ilsam@gmail.com';

  // Fetch the news data
  getNews() async {
    NewsApi newsApi = NewsApi();
    await newsApi.getNews();
    setState(() {
      articles = newsApi.dataStore;
      filteredArticles = List.from(articles); // Initially, show all articles
      isLoading = false;
    });

    // Debugging to ensure articles are loaded
    print('Articles loaded: ${articles.length}');
  }

  void navigateToUserProfile() async {
    final updatedProfile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          userName: userName,
          userEmail: userEmail,
        ),
      ),
    );

    // If the updated profile is not null, update the state
    if (updatedProfile != null) {
      setState(() {
        userName = updatedProfile['name']; // Update name
        userEmail = updatedProfile['email']; // Update email
      });
    }
  }

  void logout() {
    // Add your logout logic here (e.g., clear user session, navigate to login screen)
    Navigator.popUntil(context, (route) => route.isFirst);
    // Replace this with the login screen navigation
  }

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  // Filter the articles based on search query
  void filterNews(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredArticles = List.from(articles); // Show all articles when search is cleared
      } else {
        filteredArticles = articles
            .where((article) =>
        (article.title?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (article.description?.toLowerCase().contains(query.toLowerCase()) ?? false))
            .toList();
      }

      // Debugging the filter functionality
      print('Search query: $query');
      print('Filtered articles count: ${filteredArticles.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Search bar container
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for search bar
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search News...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                  style: const TextStyle(color: Colors.black), // Black text
                  onChanged: filterNews, // Trigger search as user types
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Search button
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                filterNews(searchController.text); // Trigger search manually if needed
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $userName', // Display updated user name
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userEmail, // Display updated user email
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Profile'),
              onTap: navigateToUserProfile, // Navigate to the UserProfileScreen
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: logout, // Trigger the logout function
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            // Category selection
            Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectedCategoryNews(
                            category: category.categoryName!,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black, // Changed to black
                        ),
                        child: Center(
                          child: Text(
                            category.categoryName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white, // White text
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Filtered news
            ListView.builder(
              itemCount: filteredArticles.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                final article = filteredArticles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetail(newsModel: article),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            article.urlToImage!,
                            height: 250,
                            width: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          article.title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Divider(thickness: 2),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
