import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:dead-threads", {
  description: "Topics with zero replies that deserve attention",
  args: {
    label: { type: "string" },
    subtitle: { type: "string" },
    count: { type: "number", default: 3 },
  },
})
export default class BlockDeadThreads extends Component {
  @bind
  async fetchDeadTopics() {
    const result = await ajax("/search.json", {
      data: {
        q: "posts_count:1 order:latest",
        page: 0,
      },
    });
    return result.topics?.slice(0, this.args.count) || [];
  }

  <template>
    <div class="block-dead-threads">
      <div class="block-dead-threads__header">
        <span class="block-dead-threads__label">
          {{i18n (themePrefix @label)}}
        </span>
        <span class="block-dead-threads__subtitle">
          {{i18n (themePrefix @subtitle)}}
        </span>
      </div>

      <AsyncContent @asyncData={{this.fetchDeadTopics}}>
        <:loading>
          <div class="block-dead-threads__list --loading">...</div>
        </:loading>
        <:content as |topics|>
          <ul class="block-dead-threads__list">
            {{#each topics as |topic|}}
              <li class="block-dead-threads__item">
                <a
                  href="/t/{{topic.slug}}/{{topic.id}}"
                  class="block-dead-threads__link"
                >
                  {{topic.title}}
                </a>
              </li>
            {{/each}}
          </ul>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
