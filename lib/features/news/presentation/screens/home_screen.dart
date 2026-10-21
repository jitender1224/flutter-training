import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../widgets/news_card.dart';
import 'news_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<String> categories = [
    'All',
    'Sports',
    'Business',
    'Politics',
    'Technology',
    'Entertainment',
    'Health',
    'Science',
  ];

  @override
  void initState() {
    super.initState();

    context.read<NewsBloc>().add(const LoadNews('All'));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        context.read<NewsBloc>().add(const LoadMoreNews());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily News',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: BlocBuilder<NewsBloc, NewsState>(
              buildWhen:
                  (previous, current) => previous.category != current.category,
              builder: (context, state) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final selected = state.category == category;

                    return Center(
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) {
                          context.read<NewsBloc>().add(LoadNews(category));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state.status == NewsStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == NewsStatus.failure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.error ?? 'Something went wrong'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed:
                                () => context.read<NewsBloc>().add(
                                  LoadNews(state.category),
                                ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state.articles.isEmpty) {
                  return const Center(child: Text('No news found'));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<NewsBloc>().add(LoadNews(state.category));
                    await context.read<NewsBloc>().stream.firstWhere(
                      (s) =>
                          s.status == NewsStatus.success ||
                          s.status == NewsStatus.failure,
                    );
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        state.articles.length +
                        (state.isLoadingMore ? 1 : 0) +
                        (state.error != null ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.articles.length) {
                        if (state.isLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return TextButton(
                          onPressed:
                              () => context.read<NewsBloc>().add(
                                const LoadMoreNews(),
                              ),
                          child: Text(
                            'Could not load more news. Tap to retry.',
                          ),
                        );
                      }

                      final article = state.articles[index];

                      return NewsCard(
                        article: article,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => NewsDetailsScreen(article: article),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
