import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import DButton from "discourse/components/d-button";
import concatClass from "discourse/helpers/concat-class";
import { popupAjaxError } from "discourse/lib/ajax-error";
import I18n from "discourse-i18n";
export default class ToggleChannelMembershipButton extends Component {
  @service chat;
  @tracked isLoading = false;
  onToggle = null;
  options = {};

  constructor() {
    super(...arguments);

    this.options = {
      labelType: "normal",
      joinTitle: I18n.t("chat.channel_settings.join_channel"),
      joinIcon: "",
      joinClass: "",
      leaveTitle: I18n.t("chat.channel_settings.leave_channel"),
      leaveIcon: "",
      leaveClass: "",
      ...this.args.options,
    };
  }

  get label() {
    if (this.options.labelType === "none") {
      return "";
    }

    if (this.options.labelType === "short") {
      if (this.args.channel.currentUserMembership.following) {
        return I18n.t("chat.channel_settings.leave");
      } else {
        return I18n.t("chat.channel_settings.join");
      }
    }

    if (this.args.channel.currentUserMembership.following) {
      return I18n.t("chat.channel_settings.leave_channel");
    } else {
      return I18n.t("chat.channel_settings.join_channel");
    }
  }

  @action
  onJoinChannel() {
    this.isLoading = true;

    return this.chat
      .followChannel(this.args.channel)
      .then(() => {
        this.onToggle?.();
      })
      .catch(popupAjaxError)
      .finally(() => {
        if (this.isDestroying || this.isDestroyed) {
          return;
        }

        this.isLoading = false;
      });
  }

  @action
  onLeaveChannel() {
    this.isLoading = true;

    return this.chat
      .unfollowChannel(this.args.channel)
      .then(() => {
        this.onToggle?.();
      })
      .catch(popupAjaxError)
      .finally(() => {
        if (this.isDestroying || this.isDestroyed) {
          return;
        }

        this.isLoading = false;
      });
  }

  <template>
    {{#if @channel.currentUserMembership.following}}
      <DButton
        @action={{this.onLeaveChannel}}
        @translatedLabel={{this.label}}
        @translatedTitle={{this.options.leaveTitle}}
        @icon={{this.options.leaveIcon}}
        @disabled={{this.isLoading}}
        class={{concatClass
          "toggle-channel-membership-button -leave"
          this.options.leaveClass
        }}
      />
    {{else}}
      <DButton
        @action={{this.onJoinChannel}}
        @translatedLabel={{this.label}}
        @translatedTitle={{this.options.joinTitle}}
        @icon={{this.options.joinIcon}}
        @disabled={{this.isLoading}}
        class={{concatClass
          "toggle-channel-membership-button -join"
          this.options.joinClass
        }}
      />
    {{/if}}
  </template>
}
