# 🤝 Contributing to Kiru

Welcome to the team! Here's how we'll work together.

---

## Git Workflow

1. **Always pull main first**:
   ```bash
   git checkout main
   git pull origin main
   ```

2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   # Or
   git checkout -b fix/your-bug-fix-name
   ```

3. **Make your changes, commit often**:
   ```bash
   git add .
   git commit -m "feat: add login screen"
   # Or
   git commit -m "fix: resolve wardrobe item delete bug"
   ```

4. **Push your branch**:
   ```bash
   git push origin feature/your-feature-name
   ```

5. **Open a Pull Request (PR)** on GitHub
   - Request review from team members
   - Link any relevant issues
   - Wait for approval before merging

---

## Commit Message Convention
We follow conventional commits:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation update
- `style:` Code style change (formatting, etc.)
- `refactor:` Code refactor
- `test:` Add/update tests
- `chore:` Build/tooling changes

---

## Code Style
- Follow Flutter best practices
- Use our design system (`lib/core/theme/app_theme.dart`)
- Write readable, maintainable code
- Add comments for complex logic

---

## Security & Privacy First
- NEVER commit API keys or secrets (use `.env`!)
- ALWAYS keep data private by default
- NEVER skip EXIF stripping on photo uploads
- Follow all security rules in `PROJECT_BRIEF.md`

---

## Have Fun!
Let's build an awesome app together! 🎉
