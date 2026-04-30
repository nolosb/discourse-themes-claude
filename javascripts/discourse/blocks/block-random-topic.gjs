import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:random-topic", {
  description: "Lucky draw — a random topic picked fresh for you",
  args: {
    title: { type: "string" },
    subtitle: { type: "string" },
  },
})
export default class BlockRandomTopic extends Component {
  @bind
  async fetchRandom() {
    const result = await ajax("/latest.json", { data: { per_page: 30 } });
    const topics = result.topic_list.topics;
    if (!topics?.length) {
      return null;
    }
    return topics[Math.floor(Math.random() * topics.length)];
  }

  <template>
    <div class="block-random-topic">
      <div class="block-random-topic__header">
        <span class="block-random-topic__icon">🎰</span>
        <h3 class="block-random-topic__title">
          {{i18n (themePrefix @title)}}
        </h3>
      </div>
      <p class="block-random-topic__subtitle">
        {{i18n (themePrefix @subtitle)}}
      </p>

      <AsyncContent @asyncData={{this.fetchRandom}}>
        <:loading>
          <div class="block-random-topic__body --loading">Spinning...</div>
        </:loading>
        <:content as |topic|>
          <a
            href="/t/{{topic.slug}}/{{topic.id}}"
            class="block-random-topic__body"
          >
            {{topic.title}}
          </a>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
