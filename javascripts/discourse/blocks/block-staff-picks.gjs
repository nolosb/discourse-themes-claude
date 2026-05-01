import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:staff-picks", {
  description: "Pinned and staff-selected topics displayed as curated picks",
  args: {
    title: { type: "string" },
  },
})
export default class BlockStaffPicks extends Component {
  @bind
  async fetchPicks() {
    const result = await ajax("/latest.json", { data: { per_page: 30 } });
    const topics = result.topic_list.topics || [];
    const pinned = topics.filter((t) => t.pinned || t.pinned_globally);
    return pinned.slice(0, 4);
  }

  <template>
    <div class="block-staff-picks">
      <h3 class="block-staff-picks__title">
        {{i18n (themePrefix @title)}}
      </h3>

      <AsyncContent @asyncData={{this.fetchPicks}}>
        <:loading>
          <div class="block-staff-picks__loading">...</div>
        </:loading>
        <:empty>
          <div class="block-staff-picks__empty">No picks right now~</div>
        </:empty>
        <:content as |topics|>
          <div class="block-staff-picks__list">
            {{#each topics as |topic|}}
              <a href="/t/{{topic.slug}}/{{topic.id}}" class="block-staff-picks__card">
                {{#if topic.image_url}}
                  <img
                    src={{topic.image_url}}
                    class="block-staff-picks__thumb"
                    loading="lazy"
                  />
                {{else}}
                  <div class="block-staff-picks__thumb --placeholder"></div>
                {{/if}}
                <div class="block-staff-picks__info">
                  <span class="block-staff-picks__badge">Staff Pick</span>
                  <h4 class="block-staff-picks__topic-title">{{topic.title}}</h4>
                </div>
              </a>
            {{/each}}
          </div>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
