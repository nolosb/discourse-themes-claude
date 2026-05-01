import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:longest-thread", {
  description: "The legendary topic with the most replies — achievement card style",
  args: {
    title: { type: "string" },
    subtitle: { type: "string" },
    period: { type: "string", default: "yearly" },
  },
})
export default class BlockLongestThread extends Component {
  @bind
  async fetchLongest() {
    const result = await ajax("/top.json", {
      data: { period: this.args.period },
    });
    const topics = result.topic_list.topics || [];
    const sorted = [...topics].sort((a, b) => b.posts_count - a.posts_count);
    return sorted[0] || null;
  }

  <template>
    <div class="block-longest-thread">
      <div class="block-longest-thread__header">
        <h3 class="block-longest-thread__title">
          {{i18n (themePrefix @title)}}
        </h3>
        <span class="block-longest-thread__subtitle">
          {{i18n (themePrefix @subtitle)}}
        </span>
      </div>

      <AsyncContent @asyncData={{this.fetchLongest}}>
        <:loading>
          <div class="block-longest-thread__card --loading">...</div>
        </:loading>
        <:empty>
          <div class="block-longest-thread__card --empty">No threads yet~</div>
        </:empty>
        <:content as |topic|>
          <a href="/t/{{topic.slug}}/{{topic.id}}" class="block-longest-thread__card">
            <span class="block-longest-thread__trophy">🏆</span>
            <h4 class="block-longest-thread__topic-title">{{topic.title}}</h4>
            <div class="block-longest-thread__stats">
              <span class="block-longest-thread__replies">{{topic.posts_count}} replies</span>
              <span class="block-longest-thread__likes">{{topic.like_count}} likes</span>
              <span class="block-longest-thread__views">{{topic.views}} views</span>
            </div>
          </a>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
