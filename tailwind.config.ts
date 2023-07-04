const formKitTailwind = require(`@formkit/themes/tailwindcss`);

module.exports = {
  plugins: [ formKitTailwind ],
  content: [ `./formkit.config.ts` ]
};