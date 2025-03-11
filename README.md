# Recipe App  

### Summary  
The **Recipe App** is a single screen app that fetches and displays recipes from the provided API. Each recipe shows its name, cuisine type, and an image. Users can refresh the list anytime, and images are loaded efficiently with a custom caching system to reduce network usage.  

**Features:**  
- Displays a list of recipes with their name, cuisine type, and image.  
- Allows users to manually refresh the list (pull to refresh).  
- Loads images efficiently with a custom disk cache to minimize network requests.  
- Handles errors including malformed or empty data responses.  
- Includes unit tests for core functionality like fetching data and caching images.  

**Screenshots:**  
| Successful | Decoding Error | Empty List |
|-------------|-------------|-------------|
| ![Screenshot 1](https://github.com/user-attachments/assets/afb41d5d-8207-4b05-be76-7cb8a0d171df) | ![Screenshot 2](https://github.com/user-attachments/assets/3637f474-1283-428c-8213-7511fb3e61b9) | ![Screenshot 3](https://github.com/user-attachments/assets/1b4da90e-a0e8-498f-9935-99b9e57d5a52) |


---

### Focus Areas  
I focused on a few key areas to make sure the app was well-structured and performed smoothly:  

- **Swift Concurrency (async/await)** – Used throughout to keep API calls and image loading efficient.  
- **Image Caching** – Built a simple, custom disk cache to avoid unnecessary downloads.  
- **Error Handling** – Handled both malformed and empty data gracefully with clear messaging.  
- **SwiftUI Best Practices** – Kept the UI clean, minimal, and easy to navigate.  
- **Unit Testing** – Focused on testing the core logic around fetching and caching data.  

---

### Time Spent  
- **Project Setup & API Integration:** ~2 hours  
- **Building the UI in SwiftUI:** ~1 hours  
- **Implementing Image Caching:** ~1 hours   
- **Unit Testing:** ~1 hours  
- **Final Touches & README:** ~1 hour  
- **Total:** ~6 hours  

---

### Trade-offs and Decisions  
- **No Third-Party Libraries:** Since the prompt required no external dependencies, I built the image caching system myself instead of using something like `SDWebImage`.  
- **Keeping the UI Simple:** The app is designed to be a straightforward recipe list, so I focused on performance and clarity rather than adding extra features like sorting or filtering.  
- **Minimal Animations:** While animations could make the experience feel smoother, I prioritized functionality and responsiveness first.  

---

### Weakest Part of the Project  
- **Limited UI Enhancements:** The UI is clean but could be improved with features like sorting, filtering, or a more interactive design.  
- **Cache Optimization:** The current caching system works, but it could be more robust with expiration policies and better memory management.  

---
