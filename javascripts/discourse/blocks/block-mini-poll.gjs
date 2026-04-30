import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { block } from "discourse/blocks";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:mini-poll", {
  description: "Cute quick poll widget — just for fun, no persistence",
  args: {
    title: { type: "string" },
    question: { type: "string" },
    option1: { type: "string" },
    option2: { type: "string" },
    option3: { type: "string" },
  },
})
export default class BlockMiniPoll extends Component {
  @tracked selected = null;

  @action
  vote(option) {
    this.selected = option;
  }

  <template>
    <div class="block-mini-poll">
      <h3 class="block-mini-poll__title">
        {{i18n (themePrefix @title)}}
      </h3>
      <p class="block-mini-poll__question">
        {{i18n (themePrefix @question)}}
      </p>

      <div class="block-mini-poll__options">
        {{#if this.selected}}
          <div class="block-mini-poll__result">
            {{this.selected}}
          </div>
        {{else}}
          <button
            type="button"
            class="block-mini-poll__btn --opt1"
            {{on "click" (fn this.vote (i18n (themePrefix @option1)))}}
          >
            {{i18n (themePrefix @option1)}}
          </button>
          <button
            type="button"
            class="block-mini-poll__btn --opt2"
            {{on "click" (fn this.vote (i18n (themePrefix @option2)))}}
          >
            {{i18n (themePrefix @option2)}}
          </button>
          <button
            type="button"
            class="block-mini-poll__btn --opt3"
            {{on "click" (fn this.vote (i18n (themePrefix @option3)))}}
          >
            {{i18n (themePrefix @option3)}}
          </button>
        {{/if}}
      </div>
    </div>
  </template>
}
