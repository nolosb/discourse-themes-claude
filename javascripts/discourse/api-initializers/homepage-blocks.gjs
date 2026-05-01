import BlockGroup from "discourse/blocks/builtin/block-group";
import { apiInitializer } from "discourse/lib/api";
import BlockEmojiHeatmap from "../blocks/block-emoji-heatmap";
import BlockFakeAd from "../blocks/block-fake-ad";
import BlockHotTags from "../blocks/block-hot-tags";
import BlockHotTopics from "../blocks/block-hot-topics";
import BlockLongestThread from "../blocks/block-longest-thread";
import BlockMiniPoll from "../blocks/block-mini-poll";
import BlockMood from "../blocks/block-mood";
import BlockNewMembers from "../blocks/block-new-members";
import BlockQuoteOfDay from "../blocks/block-quote-of-day";
import BlockRandomTopic from "../blocks/block-random-topic";
import BlockRankings from "../blocks/block-rankings";
import BlockStaffPicks from "../blocks/block-staff-picks";
import BlockTicker from "../blocks/block-ticker";
import BlockWelcomeHeader from "../blocks/block-welcome-header";

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
                period: settings.homepage_period,
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
            {
              block: BlockStaffPicks,
              id: "staff-picks",
              args: {
                title: "homepage.staff_picks.title",
              },
            },
            {
              block: BlockQuoteOfDay,
              id: "quote-of-day",
              args: {
                title: "homepage.quote_of_day.title",
                period: settings.homepage_period,
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
                period: settings.homepage_period,
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
                period: settings.homepage_period,
              },
            },
            {
              block: BlockLongestThread,
              id: "longest-thread",
              args: {
                title: "homepage.longest_thread.title",
                subtitle: "homepage.longest_thread.subtitle",
                period: settings.homepage_period,
              },
            },
            {
              block: BlockFakeAd,
              id: "fake-ad",
              args: {
                headline: "homepage.fake_ad.headline",
                subtext: "homepage.fake_ad.subtext",
                cta: "homepage.fake_ad.cta",
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
            {
              block: BlockEmojiHeatmap,
              id: "emoji-heatmap",
              args: {
                title: "homepage.emoji_heatmap.title",
              },
            },
            {
              block: BlockHotTags,
              id: "hot-tags",
              args: {
                title: "homepage.hot_tags.title",
              },
            },
          ],
        },
      ],
    },
  ]);
});
