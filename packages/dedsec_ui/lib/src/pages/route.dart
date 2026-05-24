/// Logical screen identifiers used by `DedsecRouter`. We keep an in-app
/// `currentScreen` value (replacing the React `s.screen` state) so that the
/// internal "go" navigation stays exactly like the prototype.
enum DedsecScreen {
  splash,
  onboarding,
  interests,
  city,
  perms,
  home,
  detail,
  generate,
  channels,
  help,
  achievements,
  forumScope,
  forumList,
  topic,
  newPost,
  settings,
}
