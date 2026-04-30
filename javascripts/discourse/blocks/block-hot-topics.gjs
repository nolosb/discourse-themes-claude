import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:hot-topics", {
  description: "Compact hot topics list with fire badges and reply counts",
  args: {
    title: { type: "string" },
    fireLabel: { type: "string" },
  },
})
export default class BlockHotTopics extends Component {
  @bind
  async fetchHot() {
    const result = await ajax("/top.json", { data: { period: "daily" } });
    return result.topic_list.topics?.slice(0, 8) || [];
  }

  <template>
    <div class="block-hot-topics">
      <h3 class="block-hot-topics__title">
        {{i18n (themePrefix @title)}}
      </h3>

      <AsyncContent @asyncData={{this.fetchHot}}>
        <:loading>
          <div class="block-hot-topics__loading">...</div>
        </:loading>
        <:content as |topics|>
          <ul class="block-hot-topics__list">
            {{#each topics as |topic index|}}
              <li class="block-hot-topics__item">
                {{#if (lt index 3)}}
                  <span class="block-hot-topics__fire">
                    {{i18n (themePrefix @fireLabel)}}
                  </span>
                {{/if}}
                <a href="/t/{{topic.slug}}/{{topic.id}}" class="block-hot-topics__link">
                  {{topic.title}}
                </a>
                <span class="block-hot-topics__replies">
                  ({{topic.posts_count}})
                </span>
              </li>
            {{/each}}
          </ul>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
