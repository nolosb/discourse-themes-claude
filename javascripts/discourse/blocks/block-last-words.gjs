import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:last-words", {
  description: "The most recent reply posted anywhere — displayed huge and raw",
  args: {
    label: { type: "string" },
  },
})
export default class BlockLastWords extends Component {
  @bind
  async fetchLastPost() {
    const result = await ajax("/posts.json");
    const posts = result.latest_posts;
    const reply = posts?.find((p) => p.post_number > 1);
    return reply || posts?.[0];
  }

  <template>
    <div class="block-last-words">
      <span class="block-last-words__label">
        {{i18n (themePrefix @label)}}
      </span>

      <AsyncContent @asyncData={{this.fetchLastPost}}>
        <:loading>
          <div class="block-last-words__quote --loading">...</div>
        </:loading>
        <:content as |post|>
          <blockquote class="block-last-words__quote">
            {{post.raw}}
          </blockquote>
          <div class="block-last-words__attribution">
            <span class="block-last-words__user">— {{post.username}}</span>
            <a
              href="/t/{{post.topic_slug}}/{{post.topic_id}}/{{post.post_number}}"
              class="block-last-words__link"
            >
              in "{{post.topic_title}}"
            </a>
          </div>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
