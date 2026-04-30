import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:time-warp", {
  description: "A random topic from exactly one year ago today",
  args: {
    label: { type: "string" },
    subtitle: { type: "string" },
  },
})
export default class BlockTimeWarp extends Component {
  @bind
  async fetchOldTopic() {
    const now = new Date();
    const oneYearAgo = new Date(now.getFullYear() - 1, now.getMonth(), now.getDate());
    const dayAfter = new Date(oneYearAgo);
    dayAfter.setDate(dayAfter.getDate() + 1);

    const formatDate = (d) => d.toISOString().split("T")[0];

    const result = await ajax("/search.json", {
      data: {
        q: `after:${formatDate(oneYearAgo)} before:${formatDate(dayAfter)}`,
        page: 0,
      },
    });

    const topics = result.topics;
    if (!topics?.length) {
      return null;
    }
    return topics[Math.floor(Math.random() * topics.length)];
  }

  <template>
    <div class="block-time-warp">
      <div class="block-time-warp__header">
        <span class="block-time-warp__label">
          {{i18n (themePrefix @label)}}
        </span>
        <span class="block-time-warp__subtitle">
          {{i18n (themePrefix @subtitle)}}
        </span>
      </div>

      <AsyncContent @asyncData={{this.fetchOldTopic}}>
        <:loading>
          <div class="block-time-warp__body --loading">Rewinding...</div>
        </:loading>
        <:empty>
          <div class="block-time-warp__body --empty">
            Nothing happened on this day last year.
          </div>
        </:empty>
        <:content as |topic|>
          <a
            href="/t/{{topic.slug}}/{{topic.id}}"
            class="block-time-warp__body"
          >
            <h3 class="block-time-warp__title">{{topic.title}}</h3>
          </a>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
