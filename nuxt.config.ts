// https://nuxt.com/docs/api/configuration/nuxt-config

// eslint-disable-next-line no-undef
export default defineNuxtConfig({
  sourcemap: process.env.NODE_ENV !== `production`,
  app: {
    head: {
      meta: [
        { name: `viewport`, content: `width=device-width, initial-scale=1` }
      ],
      title: `//TODO AY TEQUILA`
    }
  },
  modules: [
    [
      `@nuxtjs/tailwindcss`,
      {
        cssPath: `@rhinos-solutions/corn-nuxt/corn_style/_tailwind.scss`,
        configPath: [`@rhinos-solutions/corn-nuxt/corn_style/_tailwind.config.ts`, `~/tailwind.config.ts`]
      }
    ],
    [
      `@formkit/nuxt`,
      {
        configFile: `~/formkit.config.ts`
      }
    ],
    [`nuxt-headlessui`, {
      prefix: ``
    }],
    `@vueuse/nuxt`
  ],

  ssr: false,
  css: [`~/assets/css/index.scss`, `@fortawesome/fontawesome-svg-core/styles.css`],
  imports: {
    autoImport: true,
    dirs: [`./corn/*`, `./_corn/*`, `./components/*`]
  },
  components: [
    {
      path: `~/components/`,
      pathPrefix: false
    }
  ],
  runtimeConfig: {
    public: {
      API_BASE_URL: process.env.API_BASE_URL,
      CLIENT_ID: process.env.CLIENT_ID,
      CLIENT_SECRET: process.env.CLIENT_SECRET
    }
  }
});
