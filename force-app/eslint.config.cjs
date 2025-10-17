// eslint.config.cjs — minimal, flat, and works with Aura/LWC structure
const globals = require("globals");

module.exports = [
  // Base JS config for all .js files
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: { ...globals.browser, ...globals.node }
    },
    rules: {
      // add base rules you want here
    }
  },

  // Loosen rules for Aura controller/helper/renderer files (these are noisy by design)
  {
    files: ["**/aura/**/{*Controller.js,*Helper.js,*Renderer.js}"],
    rules: {
      "no-unused-expressions": "off",
      "no-unused-vars": "off",
      "vars-on-top": "off"
    }
  },

  // (Optional) LWC tests: allow jest globals if you have them
  {
    files: ["**/lwc/**/*.test.js"],
    languageOptions: {
      globals: {
        jest: true,
        expect: true,
        describe: true,
        it: true,
        beforeEach: true,
        afterEach: true
      }
    },
    rules: {
      // tweak LWC test rules here if needed
    }
  }
];
