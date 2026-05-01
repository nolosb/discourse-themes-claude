import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:quote-of-day", {
  description: "A random highly-liked post displayed as a decorative pull quote",
  args: {
    title: { type: "string" },
    period: { type: "string", default: "yearly" },
  },
})
export default class BlockQuoteOfDay extends Component {
  @bind
  async fetchQuote() {
    const result = await ajax("/search.json", {
      data: {
        q: "order:likes min_posts:1",
        page: 0,
      },
    });
    const posts = result.posts || [];
    if (!posts.length) {
      return null;
    }
    const top = posts.slice(0, 10);
    return top[Math.floor(Math.random() * top.length)];
  }

  <template>
    <div class="block-quote-of-day">
      <h3 class="block-quote-of-day__title">
        {{i18n (themePrefix @title)}}
      </h3>

      <AsyncContent @asyncData={{this.fetchQuote}}>
        <:loading>
          <div class="block-quote-of-day__card --loading">...</div>
        </:loading>
        <:empty>
          <div class="block-quote-of-day__card --empty">No quotes yet~</div>
        </:empty>
        <:content as |post|>
          <a
            href="/t/{{post.topic_slug}}/{{post.topic_id}}/{{post.post_number}}"
            class="block-quote-of-day__card"
          >
            <blockquote class="block-quote-of-day__text">
              {{post.blurb}}
            </blockquote>
            <div class="block-quote-of-day__attribution">
              <img
                src={{post.avatar_template}}
                width="32"
                height="32"
                class="block-quote-of-day__avatar"
                loading="lazy"
              />
              <span class="block-quote-of-day__author">{{post.username}}</span>
              <span class="block-quote-of-day__likes">{{post.like_count}} ♥</span>
            </div>
          </a>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
