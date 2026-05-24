/**
 * @file app/index — root composition. Picks the screen based on app state
 * and hands a ready-to-render tree to the AppShell template.
 */

function App() {
  const s = useAppState();

  const renderScreen = () => {
    switch (s.screen) {
      case 'splash':     return <ScreenSplash    go={s.go}/>;
      case 'onb1':       return <ScreenOnboarding go={s.go}/>;
      case 'interests':  return <ScreenInterests go={s.go}/>;
      case 'city':       return <ScreenCity      go={s.go}/>;
      case 'perms':      return <ScreenPerms     go={s.go}/>;
      case 'home':       return <ScreenHome      go={s.go} tab={s.tab} setTab={s.goTab}/>;
      case 'detail':     return <ScreenDetail    go={s.go}/>;
      case 'generate':   return <ScreenGenerate  go={s.go}/>;
      case 'channels':   return <ScreenChannels  go={s.go}/>;
      case 'help':       return <ScreenHelp      go={s.go} tab={s.tab} setTab={s.goTab} user={s.user}/>;
      case 'achievements': return <ScreenAchievements go={s.go} user={s.user}/>;
      case 'forum':      return <ScreenForumScope go={s.go} tab={s.tab} setTab={s.goTab} user={s.user} topics={s.topics} setForumScope={s.setForumScope}/>;
      case 'forum-list': return <ScreenForumList  go={s.go} tab={s.tab} setTab={s.goTab} user={s.user} topics={s.topics} forumScope={s.forumScope} markTopicSeen={s.markTopicSeen} setCurrentTopic={s.setCurrentTopic}/>;
      case 'topic':      return <ScreenTopic      go={s.go} user={s.user} replies={s.topicReplies} addReply={s.addReply} deleteReply={s.deleteReply} currentTopic={s.currentTopic}/>;
      case 'newpost':    return <ScreenNewPost    go={s.go} user={s.user} addTopic={s.addTopic} setForumScope={s.setForumScope}/>;
      case 'settings':   return <ScreenSettings   go={s.go} tab={s.tab} setTab={s.goTab} user={s.user} setUser={s.setUser} regenerateUser={s.regenerateUser}/>;
      default:
        if (LOADER_COMP[s.screen]) {
          const meta = LOADER_META[s.screen];
          return <LoaderShowcase id={s.screen.toUpperCase()} title={meta.title} subtitle={meta.sub} Component={LOADER_COMP[s.screen]}/>;
        }
        return null;
    }
  };

  return <AppShell screen={s.screen} go={s.go} renderScreen={renderScreen}/>;
}

ReactDOM.createRoot(document.getElementById('root')).render(<App/>);
