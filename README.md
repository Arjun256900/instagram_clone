# InstaClone – Fullstack Instagram Clone

A full-fledged Instagram clone built from scratch using Flutter, Microservices, Firebase, MongoDB, Socket.io, Docker, Kubernetes, and WebRTC.
Supports light/dark mode, pixel-perfect UI, custom theme-aware icons, and scalable architecture.

## Features

- Pixel-perfect Instagram-style UI
- Dark/Light theme support (auto-detect system theme)
- Custom icons for theme-aware toggle states
- Clean folder structure using feature-driven architecture
- Auth screens with reusable widgets
- Fully modular – prepped for microservice integration
- Coming soon: Post, Reels, Stories, DM (real-time), and AI Captioning

## Tech Stack

| Frontend | Backend | Realtime | Storage | Infra |
| -------- | ------- | -------- | ------- | ----- |
| Flutter  | Node.js(mircoservices) | Socket.io | Firebase Storage | Docker + Kubernetes |
| Riverpod | MongoDB | JWT Auth |         | CI/CD (soon)

## Development diary

| Date | Update |
| ---- | ------ | 
| 31st March 2025 | Flutter UI microservices initialized |
| 1st April | Login and Signup UI structured |
| 2nd April | Fully polished Login and SignUp screens |
| 3rd April | First backend microservice (Auth) initialized and dockerized |
| 4th April | Nginx request routing setup with rate limiting for auth endpoints |
| 5th to 7th April | Login and SignUp logic integrated with a starters User model using MongoDB and tested with cURL |
| 9th April | Flutter UI integration with the Auth microservice and Api Gateway microservices |
| 12th April | Started the second UI microservice (User profile screen) |

## What's next?

 - Post upload UI
 - Feed & infinite scroll
 - AI-powered captioning (GPT microservice)
 - Stories & Reels UI
 - Backend microservices
 - Socket.io for real-time DMs
 - Full CI/CD pipeline (Jenkins/GitLab TBD)
 -  Deploy on Render/Heroku or self-host

## Contributing

TBD once backend is up. Will open issues + provide guidelines.

## Author

- 👨‍💻 Made with 💪 and ☕ by [Arjun](https://github.com/Arjun256900)
- ⭐️ If you find this project helpful, give it a star!” and “Feel free to open issues or PRs.

## Licence

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
