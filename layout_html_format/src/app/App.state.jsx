/**
 * @file app/App.state — top-level state composition.
 * Wires user, topics, forum nav, and route together.
 */

/**
 * @returns {{
 *   user: DedsecUser, setUser: Function, regenerateUser: Function,
 *   topics: ForumTopic[], addTopic: Function, markTopicSeen: Function,
 *   topicReplies: ForumReply[], addReply: Function, deleteReply: Function,
 *   forumScope: 'mun'|'est'|'fed', setForumScope: Function,
 *   currentTopic: ForumTopic|null, setCurrentTopic: Function,
 *   screen: string, setScreen: Function, go: (s: string) => void,
 *   tab: string, setTab: Function, goTab: (t: string) => void,
 * }}
 */
function useAppState() {
  const { user, setUser, regenerateUser } = useUser();
  const { topics, addTopic, markTopicSeen, topicReplies, addReply, deleteReply } = useTopics(user);
  const { forumScope, setForumScope, currentTopic, setCurrentTopic } = useForumNav();

  const [screen, setScreen] = React.useState('splash');
  const [tab, setTab]       = React.useState('home');

  const goTab = React.useCallback((t) => {
    setTab(t);
    if (t === 'home')     setScreen('home');
    if (t === 'help')     setScreen('help');
    if (t === 'forum')    setScreen('forum');
    if (t === 'settings') setScreen('settings');
  }, []);

  const go = React.useCallback((s) => {
    setScreen(s);
    if (s === 'home') setTab('home');
    if (s === 'help') setTab('help');
    if (s === 'forum' || s === 'forum-list' || s === 'topic' || s === 'newpost') setTab('forum');
    if (s === 'settings') setTab('settings');
  }, []);

  return {
    user, setUser, regenerateUser,
    topics, addTopic, markTopicSeen, topicReplies, addReply, deleteReply,
    forumScope, setForumScope, currentTopic, setCurrentTopic,
    screen, setScreen, go, tab, setTab, goTab,
  };
}

Object.assign(window, { useAppState });
