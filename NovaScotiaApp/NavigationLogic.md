# Логика и навигация — предложения

## 1. Точка входа (корневой поток)

**Рекомендация:** один корневой экран, который решает, что показывать.

- **Первый запуск:** Onboarding → Create Profile (или пропуск → Create Profile).
- **Нет пользователя (не залогинен):** Create Profile.
- **Есть пользователь (Firebase Auth):** MainTabView.

Флаги: `UserDefaults` — «онбординг показан»; состояние авторизации — `AuthService.shared.currentUser != nil`.

---

## 2. Create Profile

- **Create Profile (успех)** → MainTabView.
- **Continue as Guest (успех)** → MainTabView.
- **Sign in** → экран входа (Sign In) → при успехе → MainTabView.

Нужен отдельный экран **Sign In** (email + пароль, вызов `AuthService.signIn`), чтобы не дублировать логику и дать переход «Already have a profile? Sign in».

---

## 3. MainTabView и табы

- **Home** — список мест, поиск, категории, избранное.
- **Explore** — сетка категорий (картинки из Explores).
- **Map** — карта и нижний лист с местами.
- **Profile** — карточка гостя/пользователя, Saved Places/Events, Settings, Help, Log Out.

Переключение табов оставить как сейчас. Для «Open in Map» с детального экрана места — переключить таб на Map и при необходимости выделить место (через общее состояние или callback из MainTabView).

---

## 4. Навигация с Home

- **Тап по карточке места** → экран детали места (PlaceDetailView) поверх таба (push или fullScreenCover). Данные: `PlaceItem` + `placeDetailData(for: place.id)`.
- **Кнопка уведомлений (колокольчик)** → экран Notifications (модально или push). Лучше sheet/fullScreenCover из MainTabView, чтобы не терять таб.
- **Кнопка Settings в хедере Home** — по макету обычно ведёт в настройки; можно вести туда же, что и Settings из Profile (один экран Settings).

---

## 5. PlaceDetailView

- **Open in Map** → переключить таб на Map и (опционально) выбрать это место на карте и в нижнем листе. Реализация: callback в MainTabView `onOpenInMap(place)` → `selectedTab = .map` + передать `place` в MapView (например, через binding/State в MainTabView).
- Экран детали места без кнопки чата (ранее планировавшаяся функция убрана).

---

## 6. Profile

- **Saved Places** → экран списка сохранённых мест (пока заглушка или пустой список; позже — данные из Firestore/UserDefaults).
- **Saved Events** → то же для событий (заглушка или пустой список).
- **Settings** → экран Settings (sheet или push). Кнопка «Назад» → закрыть и вернуться в Profile.
- **Help** → экран Help (заглушка или WebView с FAQ/ссылкой).
- **Log Out** → `AuthService.signOut()`, затем корень показывает снова Create Profile (или экран входа, если решите всегда показывать только его после выхода).

---

## 7. Settings

- **Back** → закрыть (dismiss) и вернуться в Profile.
- **Reset data** → уточнить: только локальные данные (UserDefaults, кэш) или ещё «удалить аккаунт». Для удаления аккаунта — `AuthService.shared.deleteAccount()` + при успехе показать Create Profile.

---

## 8. Notifications

- **Back** → закрыть и вернуться на экран, откуда открыли (Home).
- **Clear all** — уже реализовано локально; при наличии бэкенда — синхронизация с сервером.

---

## 9. Explore

- **Тап по картинке** — пока заглушка или переход на список мест по категории (если позже привяжете категории к explore1…explore8).

---

## 10. Что имеет смысл сделать в коде сейчас

1. **Корневой экран (AppRootView)** — выбор: Onboarding / Create Profile / MainTabView по флагу онбординга и `AuthService.currentUser`.
2. **Экран Sign In** — email, пароль, кнопка «Sign in», вызов AuthService, при успехе — переход на MainTabView.
3. **Связка Create Profile с корнем** — после успешного создания профиля или гостя — перейти на MainTabView; при «Sign in» — открыть Sign In.
4. **Связка Profile → Log Out** — вызов AuthService.signOut(), корень переключается на Create Profile.
5. **Home в NavigationStack** — тап по карточке места → push PlaceDetailView с `place` и `placeDetailData(for: place.id)`.
6. **MainTabView** — передать в Home/Profile колбэки для открытия Notifications и Settings (sheet) и при необходимости callback для «Open in Map» (смена таба + место).

Дальше можно по шагам: сначала корень + Sign In + Log Out, потом навигация к детали места и «Open in Map», затем Saved Places/Events и Help.

---

## Реализовано (код)

- **AppRootView** — корневой экран: выбор между Onboarding / Create Profile / Sign In / Main по флагу онбординга и `AuthService.currentUser`.
- **SignInView** — экран входа (email, пароль), вызов `AuthService.signIn`, при успехе переход в Main.
- **MainTabView** — принимает `onLogOut`; при выходе вызывается переданный колбэк (в AppRootView — signOut и переход на Create Profile). Settings и Notifications открываются sheet’ами. Home обёрнут в NavigationStack: тап по карточке места → push PlaceDetailView; «Open in Map» переключает таб на Map.
- **HomeView** — добавлены `onPlaceTap` и `onNotificationsTap`; карточки мест открывают детальный экран.
- **PlaceItem** — добавлен протокол `Hashable` для использования в `navigationDestination(item:)`.

**Чтобы запустить поток:** в точке входа приложения (SceneDelegate или корень SwiftUI) показывать `AppRootView()`. В `AppDelegate` при старте вызвать `FirebaseApp.configure()`.
