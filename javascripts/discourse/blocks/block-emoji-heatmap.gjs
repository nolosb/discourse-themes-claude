import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:emoji-heatmap", {
  description: "Most used emojis/reactions displayed huge and bouncing",
  args: {
    title: { type: "string" },
  },
})
export default class BlockEmojiHeatmap extends Component {
  @bind
  async fetchEmojis() {
    const result = await ajax("/posts.json");
    const posts = result.latest_posts || [];
    const counts = {};

    for (const post of posts) {
      const reactions = post.reactions || [];
      for (const reaction of reactions) {
        const name = reaction.id;
        counts[name] = (counts[name] || 0) + reaction.count;
      }
    }

    return Object.entries(counts)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 12)
      .map(([name, count]) => ({ name, count }));
  }

  <template>
    <div class="block-emoji-heatmap">
      <h3 class="block-emoji-heatmap__title">
        {{i18n (themePrefix @title)}}
      </h3>

      <AsyncContent @asyncData={{this.fetchEmojis}}>
        <:loading>
          <div class="block-emoji-heatmap__loading">~</div>
        </:loading>
        <:empty>
          <div class="block-emoji-heatmap__empty">No emojis yet~</div>
        </:empty>
        <:content as |emojis|>
          <div class="block-emoji-heatmap__grid">
            {{#each emojis as |emoji index|}}
              <div class="block-emoji-heatmap__item" style="animation-delay: {{index}}00ms">
                <img
                  src="/images/emoji/twitter/{{emoji.name}}.png"
                  alt={{emoji.name}}
                  class="block-emoji-heatmap__img"
                  loading="lazy"
                />
                <span class="block-emoji-heatmap__count">{{emoji.count}}</span>
              </div>
            {{/each}}
          </div>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
