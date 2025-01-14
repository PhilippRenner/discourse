import Component from "@ember/component";
import I18n from "I18n";
import discourseComputed from "discourse-common/utils/decorators";

export default Component.extend({
  tagName: "",

  @discourseComputed("type")
  label(type) {
    return I18n.t(`groups.manage.logs.${type}`);
  },

  @discourseComputed("value", "type")
  filterText(value, type) {
    return type === "action"
      ? I18n.t(`group_histories.actions.${value}`)
      : value;
  },
});
