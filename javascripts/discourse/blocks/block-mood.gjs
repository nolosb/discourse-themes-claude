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
  },
})
export default class BlockMood extends Component {
  @bind
  async fetchMood() {
    const result = await ajax("/about.json");
    return result.about.stats;
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
        <:content as |stats|>
          <div class="block-mood__gauges">
            <div class="block-mood__gauge --pink">
              <span class="block-mood__value">{{stats.posts_last_day}}</span>
              <span class="block-mood__label">{{i18n (themePrefix @postsLabel)}}</span>
            </div>
            <div class="block-mood__gauge --lavender">
              <span class="block-mood__value">{{stats.topics_last_day}}</span>
              <span class="block-mood__label">{{i18n (themePrefix @topicsLabel)}}</span>
            </div>
            <div class="block-mood__gauge --mint">
              <span class="block-mood__value">{{stats.likes_last_day}}</span>
              <span class="block-mood__label">{{i18n (themePrefix @likesLabel)}}</span>
            </div>
          </div>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
