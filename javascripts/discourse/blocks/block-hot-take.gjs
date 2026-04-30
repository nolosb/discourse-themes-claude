import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:hot-take", {
  description: "The single most liked post from the last 24 hours",
  args: {
    label: { type: "string" },
    subtitle: { type: "string" },
  },
})
export default class BlockHotTake extends Component {
  @bind
  async fetchHotPost() {
    const result = await ajax("/search.json", {
      data: {
        q: "order:likes after:1d",
        page: 0,
      },
    });
    return result.posts?.[0];
  }

  <template>
    <div class="block-hot-take">
      <div class="block-hot-take__header">
        <span class="block-hot-take__label">
          {{i18n (themePrefix @label)}}
        </span>
        <span class="block-hot-take__subtitle">
          {{i18n (themePrefix @subtitle)}}
        </span>
      </div>

      <AsyncContent @asyncData={{this.fetchHotPost}}>
        <:loading>
          <div class="block-hot-take__body --loading">...</div>
        </:loading>
        <:empty>
          <div class="block-hot-take__body --empty">
            Nothing burned hot enough today.
          </div>
        </:empty>
        <:content as |post|>
          <a
            href="/t/{{post.topic_slug}}/{{post.topic_id}}/{{post.post_number}}"
            class="block-hot-take__body"
          >
            <p class="block-hot-take__excerpt">{{post.blurb}}</p>
            <div class="block-hot-take__footer">
              <span class="block-hot-take__user">{{post.username}}</span>
              <span class="block-hot-take__likes">{{post.like_count}} ♥</span>
            </div>
          </a>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
