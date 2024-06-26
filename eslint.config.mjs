import typescriptPlugin from "@typescript-eslint/eslint-plugin";
import typescriptParser from "@typescript-eslint/parser";
import prettierPlugin from "eslint-plugin-prettier";

export default [
  {
    files: ["**/*.{ts,tsx,js,jsx}"],
    languageOptions: {
      parser: typescriptParser,
    },
    plugins: {
      "@typescript-eslint": typescriptPlugin,
      prettier: prettierPlugin,
    },
    rules: {
      "@typescript-eslint/no-unused-vars": "warn",
      curly: "warn",
      "dot-notation": "warn",
      "no-console": [
        "warn",
        {
          allow: ["warn", "error", "info"],
        },
      ],
      "no-else-return": "warn",
      "no-lonely-if": "warn",
      "no-restricted-globals": "off",
      "no-restricted-syntax": [
        "warn",
        {
          message: "Use 't(...)' instead of literal text in JSX",
          selector: "JSXText[value=/\\w/]",
        },
      ],
      "no-unneeded-ternary": "warn",
      "no-unused-expressions": "warn",
      "no-unused-vars": "off",
      "no-useless-return": "warn",
      "no-var": "warn",
      "object-shorthand": "warn",
      "one-var": ["warn", "never"],
      "prefer-arrow-callback": "warn",
      "prefer-const": [
        "warn",
        {
          destructuring: "all",
        },
      ],
      "prefer-template": "warn",
      "prettier/prettier": "warn",
    },
  },
];
