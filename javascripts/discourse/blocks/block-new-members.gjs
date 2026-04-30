import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:new-members", {
  description: "Recently joined members displayed as cute avatar cards",
  args: {
    title: { type: "string" },
    welcomeMsg: { type: "string" },
  },
})
export default class BlockNewMembers extends Component {
  @bind
  async fetchNewUsers() {
    const result = await ajax("/directory_items.json", {
      data: { period: "weekly", order: "days_visited", page: 0 },
    });
    return result.directory_items?.slice(0, 8) || [];
  }

  <template>
    <div class="block-new-members">
      <h3 class="block-new-members__title">
        {{i18n (themePrefix @title)}}
      </h3>

      <AsyncContent @asyncData={{this.fetchNewUsers}}>
        <:loading>
          <div class="block-new-members__loading">...</div>
        </:loading>
        <:content as |items|>
          <div class="block-new-members__grid">
            {{#each items as |item|}}
              <a href="/u/{{item.user.username}}" class="block-new-members__card">
                <img
                  src={{item.user.avatar_template}}
                  width="45"
                  height="45"
                  class="block-new-members__avatar"
                  loading="lazy"
                />
                <span class="block-new-members__name">{{item.user.username}}</span>
              </a>
            {{/each}}
          </div>
          <p class="block-new-members__welcome">
            {{i18n (themePrefix @welcomeMsg)}}
          </p>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
