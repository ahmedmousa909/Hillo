# HILLO V0.1

A mobile-first PWA prototype for the HILLO local-help marketplace.

## What is included
- Home/dashboard
- Search and categories
- Create a task
- Task details
- Helper booking flow (demo)
- Helper profile
- LocalStorage persistence
- PWA manifest
- Responsive mobile UI

## Important
This is a prototype/demo. It does NOT yet include:
- real authentication
- real database
- real payments/payouts
- identity verification
- production security
- legal/tax onboarding
- live GPS/maps
- real chat/notifications

## Fastest way to test on a phone
You need to host the files on a web host. For the first test, upload `index.html` and `manifest.webmanifest` to a static host such as Cloudflare Pages or GitHub Pages.

Then open the URL on Android Chrome and choose "Add to Home screen".

## Next production step
Replace LocalStorage with Supabase:
users, services, tasks, bookings, messages, reviews.
Then add authentication and Row Level Security before handling real user data.
