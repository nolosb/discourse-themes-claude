import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:ticker", {
  description: "Scrolling news ticker with latest topic titles marquee-style",
  args: {
    fallbackText: { type: "string" },
    newLabel: { type: "string" },
  },
})
export default class BlockTicker extends Component {
  @bind
  async fetchLatest() {
    const result = await ajax("/latest.json", { data: { per_page: 8 } });
    return result.topic_list.topics;
  }

  <template>
    <div class="block-ticker">
      <span class="block-ticker__badge">
        {{i18n (themePrefix @newLabel)}}
      </span>
      <div class="block-ticker__track">
        <AsyncContent @asyncData={{this.fetchLatest}}>
          <:loading>
            <span class="block-ticker__scroll">{{@fallbackText}}</span>
          </:loading>
          <:content as |topics|>
            <span class="block-ticker__scroll">
              {{#each topics as |topic|}}
                <a href="/t/{{topic.slug}}/{{topic.id}}" class="block-ticker__item">
                  {{topic.title}}
                </a>
                <span class="block-ticker__sep">&star;</span>
              {{/each}}
            </span>
          </:content>
        </AsyncContent>
      </div>
    </div>
  </template>
}
