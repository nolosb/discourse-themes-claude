import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { bind } from "discourse/lib/decorators";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:rankings", {
  description: "Weekly user rankings with crown badges — most liked, most active",
  args: {
    title: { type: "string" },
    likesLabel: { type: "string" },
    postsLabel: { type: "string" },
    count: { type: "number", default: 5 },
    period: { type: "string", default: "yearly" },
  },
})
export default class BlockRankings extends Component {
  @bind
  async fetchRankings() {
    const [likesResult, postsResult] = await Promise.all([
      ajax("/directory_items.json", {
        data: { period: this.args.period, order: "likes_given", page: 0 },
      }),
      ajax("/directory_items.json", {
        data: { period: this.args.period, order: "post_count", page: 0 },
      }),
    ]);
    return {
      topLikers: likesResult.directory_items?.slice(0, this.args.count) || [],
      topPosters: postsResult.directory_items?.slice(0, this.args.count) || [],
    };
  }

  rankEmoji(index) {
    const medals = ["🥇", "🥈", "🥉", "4.", "5.", "6.", "7.", "8.", "9.", "10."];
    return medals[index] || `${index + 1}.`;
  }

  <template>
    <div class="block-rankings">
      <h3 class="block-rankings__title">
        {{i18n (themePrefix @title)}}
      </h3>

      <AsyncContent @asyncData={{this.fetchRankings}}>
        <:loading>
          <div class="block-rankings__loading">Loading...</div>
        </:loading>
        <:content as |data|>
          <div class="block-rankings__columns">
            <div class="block-rankings__column">
              <h4 class="block-rankings__subtitle --pink">
                {{i18n (themePrefix @likesLabel)}}
              </h4>
              <ol class="block-rankings__list">
                {{#each data.topLikers as |item index|}}
                  <li class="block-rankings__entry">
                    <span class="block-rankings__rank">{{this.rankEmoji index}}</span>
                    <a href="/u/{{item.user.username}}" class="block-rankings__user">
                      {{item.user.username}}
                    </a>
                    <span class="block-rankings__score">{{item.likes_given}}</span>
                  </li>
                {{/each}}
              </ol>
            </div>
            <div class="block-rankings__column">
              <h4 class="block-rankings__subtitle --purple">
                {{i18n (themePrefix @postsLabel)}}
              </h4>
              <ol class="block-rankings__list">
                {{#each data.topPosters as |item index|}}
                  <li class="block-rankings__entry">
                    <span class="block-rankings__rank">{{this.rankEmoji index}}</span>
                    <a href="/u/{{item.user.username}}" class="block-rankings__user">
                      {{item.user.username}}
                    </a>
                    <span class="block-rankings__score">{{item.post_count}}</span>
                  </li>
                {{/each}}
              </ol>
            </div>
          </div>
        </:content>
      </AsyncContent>
    </div>
  </template>
}
