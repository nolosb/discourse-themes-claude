import BlockGroup from "discourse/blocks/builtin/block-group";
import { apiInitializer } from "discourse/lib/api";
import BlockTicker from "../blocks/block-ticker";
import BlockWelcomeHeader from "../blocks/block-welcome-header";
import BlockRankings from "../blocks/block-rankings";
import BlockHotTopics from "../blocks/block-hot-topics";
import BlockNewMembers from "../blocks/block-new-members";
import BlockMood from "../blocks/block-mood";
import BlockRandomTopic from "../blocks/block-random-topic";
import BlockMiniPoll from "../blocks/block-mini-poll";

export default apiInitializer((api) => {
  api.renderBlocks("homepage-blocks", [
    {
      block: BlockTicker,
      id: "ticker",
      args: {
        fallbackText: settings.marquee_text,
        newLabel: "homepage.ticker.new",
      },
    },
    {
      block: BlockWelcomeHeader,
      id: "welcome",
      args: {
        title: "homepage.welcome.title",
        dateLabel: "homepage.welcome.date_label",
        membersOnlineLabel: "homepage.welcome.members_online",
        showClouds: settings.show_clouds,
      },
    },
    {
      block: BlockGroup,
      id: "main-grid",
      children: [
        {
          block: BlockGroup,
          id: "left-column",
          children: [
            {
              block: BlockHotTopics,
              id: "hot-topics",
              args: {
                title: "homepage.hot_topics.title",
                fireLabel: "homepage.hot_topics.fire",
              },
            },
            {
              block: BlockNewMembers,
              id: "new-members",
              args: {
                title: "homepage.new_members.title",
                welcomeMsg: "homepage.new_members.welcome_msg",
              },
            },
          ],
        },
        {
          block: BlockGroup,
          id: "center-column",
          children: [
            {
              block: BlockRankings,
              id: "rankings",
              args: {
                title: "homepage.rankings.title",
                likesLabel: "homepage.rankings.likes_given",
                postsLabel: "homepage.rankings.posts",
                count: settings.ranking_count,
              },
            },
            {
              block: BlockMood,
              id: "mood",
              args: {
                title: "homepage.mood.title",
                postsLabel: "homepage.mood.posts_today",
                topicsLabel: "homepage.mood.topics_today",
                likesLabel: "homepage.mood.likes_today",
              },
            },
          ],
        },
        {
          block: BlockGroup,
          id: "right-column",
          children: [
            {
              block: BlockRandomTopic,
              id: "random-topic",
              args: {
                title: "homepage.random_topic.title",
                subtitle: "homepage.random_topic.subtitle",
              },
            },
            {
              block: BlockMiniPoll,
              id: "mini-poll",
              args: {
                title: "homepage.mini_poll.title",
                question: "homepage.mini_poll.question",
                option1: "homepage.mini_poll.great",
                option2: "homepage.mini_poll.okay",
                option3: "homepage.mini_poll.sleepy",
              },
            },
          ],
        },
      ],
    },
  ]);
});
