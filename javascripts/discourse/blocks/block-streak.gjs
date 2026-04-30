import Component from "@glimmer/component";
import { service } from "@ember/service";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:streak", {
  description: "User with the longest visit streak — displayed as a trophy slab",
  args: {
    label: { type: "string" },
    subtitle: { type: "string" },
  },
})
export default class BlockStreak extends Component {
  @service currentUser;

  @bind
  async fetchTopUser() {
    const result = await ajax("/directory_items.json", {
      data: {
        period: "all",
        order: "days_visited",
        asc: false,
        page: 0,
      },
    });
    return result.directory_items?.[0];
  }

  <template>
    <div class="block-streak">
      <span class="block-streak__label">
        {{i18n (themePrefix @label)}}
      </span>

      <AsyncContent @asyncData={{this.fetchTopUser}}>
        <:loading>
          <div class="block-streak__body --loading">—</div>
        </:loading>
        <:content as |item|>
          <div class="block-streak__body">
            <span class="block-streak__number">
              {{item.days_visited}}
            </span>
            <span class="block-streak__subtitle">
              {{i18n (themePrefix @subtitle)}}
            </span>
            <a
              href="/u/{{item.user.username}}"
              class="block-streak__user"
            >
              {{item.user.username}}
            </a>
          </div>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
