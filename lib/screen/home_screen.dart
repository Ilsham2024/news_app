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
      filteredArticles = List.from(articles);
      isLoading = false;
    });


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

    //
    if (updatedProfile != null) {
      setState(() {
        userName = updatedProfile['name']; // Update name
        userEmail = updatedProfile['email']; // Update email
      });
    }
  }

  void logout() {

    Navigator.popUntil(context, (route) => route.isFirst);

  }

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }


  void filterNews(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredArticles = List.from(articles);
      } else {
        filteredArticles = articles
            .where((article) =>
        (article.title?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (article.description?.toLowerCase().contains(query.toLowerCase()) ?? false))
            .toList();
      }


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

            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search News...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: filterNews,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Search button
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                filterNews(searchController.text); //
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
                    'Hello, $userName', //
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userEmail, //
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
              onTap: navigateToUserProfile,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: logout,
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
                          color: Colors.black,
                        ),
                        child: Center(
                          child: Text(
                            category.categoryName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
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
