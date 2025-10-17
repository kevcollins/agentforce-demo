// eslint.config.js — ESLint v9 flat config
const globals = require("globals");

module.exports = [
  // Base JS everywhere
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: { ...globals.browser, ...globals.node }
    }
  },

  // LWC: allow decorators (@api, @wire, @track)
  {
    files: ["**/lwc/**/*.js"],
    languageOptions: {
      parser: require("@babel/eslint-parser"),
      parserOptions: {
        requireConfigFile: false,
        babelOptions: {
          // Enable legacy decorators + class fields for LWC syntax
          plugins: [
            ["@babel/plugin-proposal-decorators", { legacy: true }],
            ["@babel/plugin-proposal-class-properties", { loose: true }]
          ]
        }
      }
    }
  },

  // Aura controllers/helpers/renderers: relax noisy rules
  {
    files: ["**/aura/**/{*Controller.js,*Helper.js,*Renderer.js}"],
    rules: {
      "no-unused-expressions": "off",
      "no-unused-vars": "off",
      "vars-on-top": "off"
    }
  },

  // Jest globals for LWC tests (if present)
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
    }
  }
];
