import BlockGroup from "discourse/blocks/builtin/block-group";
import { apiInitializer } from "discourse/lib/api";
import BlockLastWords from "../blocks/block-last-words";
import BlockLurkers from "../blocks/block-lurkers";
import BlockHotTake from "../blocks/block-hot-take";
import BlockDeadThreads from "../blocks/block-dead-threads";
import BlockTimeWarp from "../blocks/block-time-warp";
import BlockStreak from "../blocks/block-streak";

export default apiInitializer((api) => {
  api.renderBlocks("homepage-blocks", [
    {
      block: BlockGroup,
      id: "brutal-top",
      children: [
        {
          block: BlockLastWords,
          id: "last-words",
          args: {
            label: "homepage.last_words.label",
          },
        },
        {
          block: BlockLurkers,
          id: "lurkers",
          args: {
            label: "homepage.lurkers.label",
          },
        },
      ],
    },
    {
      block: BlockHotTake,
      id: "hot-take",
      args: {
        label: "homepage.hot_take.label",
        subtitle: "homepage.hot_take.subtitle",
      },
    },
    {
      block: BlockGroup,
      id: "brutal-bottom",
      children: [
        {
          block: BlockDeadThreads,
          id: "dead-threads",
          args: {
            label: "homepage.dead_threads.label",
            subtitle: "homepage.dead_threads.subtitle",
            count: settings.dead_threads_count,
          },
        },
        {
          block: BlockGroup,
          id: "brutal-bottom-right",
          children: [
            {
              block: BlockTimeWarp,
              id: "time-warp",
              args: {
                label: "homepage.time_warp.label",
                subtitle: "homepage.time_warp.subtitle",
              },
            },
            {
              block: BlockStreak,
              id: "streak",
              args: {
                label: "homepage.streak.label",
                subtitle: "homepage.streak.subtitle",
              },
            },
          ],
        },
      ],
    },
  ]);
});
