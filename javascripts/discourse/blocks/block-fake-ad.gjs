import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import { i18n } from "discourse-i18n";

@block("theme:claude-1:fake-ad", {
  description: "Tongue-in-cheek fake advertisement banner",
  args: {
    headline: { type: "string" },
    subtext: { type: "string" },
    cta: { type: "string" },
  },
})
export default class BlockFakeAd extends Component {
  <template>
    <div class="block-fake-ad">
      <div class="block-fake-ad__badge">AD</div>
      <div class="block-fake-ad__body">
        <div class="block-fake-ad__headline">
          {{i18n (themePrefix @headline)}}
        </div>
        <div class="block-fake-ad__subtext">
          {{i18n (themePrefix @subtext)}}
        </div>
        <a href="/about" class="block-fake-ad__cta">
          {{i18n (themePrefix @cta)}}
        </a>
      </div>
    </div>
  </template>
}
