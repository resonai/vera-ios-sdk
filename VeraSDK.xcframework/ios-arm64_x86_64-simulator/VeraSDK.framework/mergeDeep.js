window.resonai = window.resonai || {};
window.resonai.internal = window.resonai.internal || {};
window.resonai.internal.reactive = window.resonai.internal.reactive || {};

// THIS FILE IS DEPRECATED
// WE NEED TO USE deepMerge FROM PLAY FE

/**
 Shamelessly copied from https://thewebdev.info/2021/03/06/how-to-deep-merge-javascript-objects/
 */

/**
 * Simple object check.
 * @param item
 * @returns {boolean}
 */
window.resonai.internal.isObject = function (item) {
  return (item && typeof item === 'object' && !Array.isArray(item));
}

window.resonai.internal.mergeReactive = function (target, source) {
  for (const key in source) {
    target[key] = source[key]
  }
}

/**
 * Deep merge two objects.
 * @param target
 * @param ...sources
 */
window.resonai.internal.mergeDeep = function (target, ...sources) {
  if (!sources.length) return target;
  const source = sources.shift();

  if (window.resonai.internal.isObject(target) && window.resonai.internal.isObject(source)) {
    for (const key in source) {
      if (window.resonai.internal.isObject(source[key])) {
        if (!target[key]) Object.assign(target, { [key]: {} });
        if (key === 'reactive') {
          window.resonai.internal.mergeReactive(target[key], source[key]);
        } else {
          window.resonai.internal.mergeDeep(target[key], source[key]);
        }
      } else {
        Object.assign(target, { [key]: source[key] });
      }
    }
  }

  return window.resonai.internal.mergeDeep(target, ...sources);
}
