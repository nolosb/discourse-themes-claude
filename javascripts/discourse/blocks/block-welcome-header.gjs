import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import { service } from "@ember/service";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:welcome-header", {
  description: "Welcome banner with date, online count, and floating clouds",
  args: {
    title: { type: "string" },
    dateLabel: { type: "string" },
    membersOnlineLabel: { type: "string" },
    showClouds: { type: "boolean", default: true },
  },
})
export default class BlockWelcomeHeader extends Component {
  @service site;

  get todayFormatted() {
    const d = new Date();
    const options = { weekday: "long", month: "long", day: "numeric" };
    return d.toLocaleDateString("en-US", options);
  }

  @bind
  async fetchOnline() {
    const result = await ajax("/about.json");
    return result.about.stats.active_users_last_day;
  }

  <template>
    <div class="block-welcome-header">
      {{#if @showClouds}}
        <div class="block-welcome-header__clouds">
          <div class="block-welcome-header__cloud --c1"></div>
          <div class="block-welcome-header__cloud --c2"></div>
          <div class="block-welcome-header__cloud --c3"></div>
          <div class="block-welcome-header__cloud --c4"></div>
          <div class="block-welcome-header__cloud --c5"></div>
        </div>
      {{/if}}

      <div class="block-welcome-header__content">
        <h1 class="block-welcome-header__title">
          {{i18n (themePrefix @title)}}
        </h1>
        <div class="block-welcome-header__meta">
          <span class="block-welcome-header__date">
            {{i18n (themePrefix @dateLabel)}}: {{this.todayFormatted}}
          </span>
          <span class="block-welcome-header__online">
            <AsyncContent @asyncData={{this.fetchOnline}}>
              <:content as |count|>
                {{i18n (themePrefix @membersOnlineLabel)}}: {{count}}
              </:content>
            </AsyncContent>
          </span>
        </div>
      </div>
    </div>
  </template>
}
