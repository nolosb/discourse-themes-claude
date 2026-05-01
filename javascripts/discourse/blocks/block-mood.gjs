import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:mood", {
  description: "Community mood meter — today's stats as cute animated gauges",
  args: {
    title: { type: "string" },
    postsLabel: { type: "string" },
    topicsLabel: { type: "string" },
    likesLabel: { type: "string" },
    period: { type: "string", default: "yearly" },
  },
})
export default class BlockMood extends Component {
  get statSuffix() {
    const map = {
      daily: "_last_day",
      weekly: "_7_days",
      monthly: "_30_days",
      quarterly: "_30_days",
      yearly: "_count",
      all: "_count",
    };
    return map[this.args.period] || "_7_days";
  }

  @bind
  async fetchMood() {
    const result = await ajax("/about.json");
    const stats = result.about.stats;
    const suffix = this.statSuffix;
    return {
      posts: stats[`posts${suffix}`] ?? stats.posts_last_day,
      topics: stats[`topics${suffix}`] ?? stats.topics_last_day,
      likes: stats[`likes${suffix}`] ?? stats.likes_last_day,
    };
  }

  <template>
    <div class="block-mood">
      <h3 class="block-mood__title">
        {{i18n (themePrefix @title)}}
      </h3>

      <AsyncContent @asyncData={{this.fetchMood}}>
        <:loading>
          <div class="block-mood__loading">~</div>
        </:loading>
        <:content as |data|>
          <div class="block-mood__gauges">
            <div class="block-mood__gauge --pink">
              <span class="block-mood__value">{{data.posts}}</span>
              <span class="block-mood__label">{{i18n (themePrefix @postsLabel)}}</span>
            </div>
            <div class="block-mood__gauge --lavender">
              <span class="block-mood__value">{{data.topics}}</span>
              <span class="block-mood__label">{{i18n (themePrefix @topicsLabel)}}</span>
            </div>
            <div class="block-mood__gauge --mint">
              <span class="block-mood__value">{{data.likes}}</span>
              <span class="block-mood__label">{{i18n (themePrefix @likesLabel)}}</span>
            </div>
          </div>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
