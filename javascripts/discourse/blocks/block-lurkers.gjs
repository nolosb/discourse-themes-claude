import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:lurkers", {
  description: "Giant anonymous user count — who is watching right now",
  args: {
    label: { type: "string" },
  },
})
export default class BlockLurkers extends Component {
  @bind
  async fetchStats() {
    const result = await ajax("/about.json");
    return result.about;
  }

  <template>
    <div class="block-lurkers">
      <AsyncContent @asyncData={{this.fetchStats}}>
        <:loading>
          <span class="block-lurkers__number --loading">—</span>
        </:loading>
        <:content as |about|>
          <span class="block-lurkers__number">
            {{about.stats.active_users_last_day}}
          </span>
        </:content>
      </AsyncContent>
      <span class="block-lurkers__label">
        {{i18n (themePrefix @label)}}
      </span>
    </div>
  </template>
}
