/**
 * @file useForumNav/index.jsx
 * Tracks which forum scope is selected and which topic is currently open.
 */

/**
 * @typedef {Object} ForumNav
 * @property {'mun'|'est'|'fed'} forumScope
 * @property {(s:'mun'|'est'|'fed') => void} setForumScope
 * @property {ForumTopic|null} currentTopic
 * @property {(t:ForumTopic) => void} setCurrentTopic
 */

/** @returns {ForumNav} */
function useForumNav() {
  const [forumScope, setForumScope]     = React.useState('mun');
  const [currentTopic, setCurrentTopic] = React.useState(null);
  return { forumScope, setForumScope, currentTopic, setCurrentTopic };
}

Object.assign(window, { useForumNav });
