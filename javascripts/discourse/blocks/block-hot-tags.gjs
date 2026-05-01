import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:hot-tags", {
  description: "Trending tags displayed as a colorful cloud at varying sizes",
  args: {
    title: { type: "string" },
  },
})
export default class BlockHotTags extends Component {
  @bind
  async fetchTags() {
    const result = await ajax("/tags.json");
    const tags = result.tags || [];
    const sorted = [...tags].sort((a, b) => b.count - a.count).slice(0, 16);
    const maxCount = sorted[0]?.count || 1;
    return sorted.map((tag) => ({
      ...tag,
      weight: Math.max(0.6, tag.count / maxCount),
    }));
  }

  <template>
    <div class="block-hot-tags">
      <h3 class="block-hot-tags__title">
        {{i18n (themePrefix @title)}}
      </h3>

      <AsyncContent @asyncData={{this.fetchTags}}>
        <:loading>
          <div class="block-hot-tags__loading">...</div>
        </:loading>
        <:content as |tags|>
          <div class="block-hot-tags__cloud">
            {{#each tags as |tag|}}
              <a
                href="/tag/{{tag.name}}"
                class="block-hot-tags__tag"
                style="font-size: calc(0.7rem + {{tag.weight}}em); opacity: calc(0.5 + {{tag.weight}} * 0.5)"
              >
                {{tag.name}}
              </a>
            {{/each}}
          </div>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
