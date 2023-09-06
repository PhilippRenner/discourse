import { getOwner as emberGetOwner, setOwner } from "@ember/application";
import deprecated from "discourse-common/lib/deprecated";

let _default = {};

export function getOwnerWithFallback(obj) {
  return emberGetOwner(obj || _default) || emberGetOwner(_default);

  return obj.container;
}

export function setDefaultOwner(container) {
  setOwner(_default, container);
}

// `this.container` is deprecated, but we can still build a container-like
// object for components to use
export function getRegister(obj) {
  const owner = getOwnerWithFallback(obj);
  const register = {
    lookup: (...args) => owner.lookup(...args),
    lookupFactory: (...args) => {
      if (owner.factoryFor) {
        return owner.factoryFor(...args);
      } else if (owner._lookupFactory) {
        return owner._lookupFactory(...args);
      }
    },

    deprecateContainer(target) {
      Object.defineProperty(target, "container", {
        get() {
          deprecated(
            "Use `this.register` or `getOwner` instead of `this.container`",
            { id: "discourse.this-container" }
          );
          return register;
        },
      });
    },
  };

  setOwner(register, owner);

  return register;
}

export function getOwner(obj) {
  deprecated(
    "Importing getOwner from `discourse-common/lib/get-owner` is deprecated. Use `import { getOwner } from '@ember/application'`, or if you still need the fallback shim, use `import { getOwnerWithFallback } from 'discourse-common/lib/get-owner';`.",
    { since: "3.2", id: "discourse.get-owner-with-fallback" }
  );
  return getOwnerWithFallback(obj);
}
