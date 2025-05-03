# 1. Introduction

BookBuddy is a Flutter-based mobile application that offers intelligent book recommendations, review analysis, and community engagement tools to enhance the reading experience.

# 2. Tech Stack

- Flutter (UI & State Management)
- Firebase Auth (User Login)
- Firestore (User data, library, reviews, threads)
- Google Books API (Book Metadata)
- OpenAI API (Summarization, Sentiment Analysis)

# 3. App Features

- Authentication: Name, email, password registration
- Preference Selection: Choose genres on signup
- Home Screen: Shows recommendations & trending books
- Book Search: By title, author, genre filters
- Book Details: Info, thumbnail, status management, reviews
- My Library: Tracks reading status; edit via bottom sheet
- Review System: Only one review per book; AI summaries
- Community Threads: Post & reply in public discussion

# 4. Firestore Structure

- /users/{uid}: Profile data + preferences
- /users/{uid}/library/{bookId}: Personalized book tracking
- /books/{bookId}/reviews: One review per user
- /discussion_threads/{threadId}/posts: Community replies

# 5. OpenAI API Use

- summarizeReviews(): Compress all reviews to short summary
- analyzeSentiment(): Classify review sentiment
- Graceful handling of errors (e.g., 429 insufficient quota)

# 6. Key Business Rules

- Search Books and get them from Google API
- Add Books to Library and track their status of your reading habits
- Community Discussion on certain book topics
- Add preferences in the profile page
- Only one review per book per user
- Can't add same book to library twice
- Profile editable post-registration
- Preferences used to shape homepage recommendations
- Summarize reviews using Open AI API
- Handling network calls and their execptions

# 7. Deployment & Testing

- Run on Android/iOS simulators/emulators
- Firebase keys required in google-services.json
- Test cases cover UI, Firestore, review restrictions

# 8. Conclusion

BookBuddy provides a user-friendly, AI-powered reading platform. With personalized suggestions, smart reviews, and community engagement, it simplifies how readers find, track, and enjoy books.