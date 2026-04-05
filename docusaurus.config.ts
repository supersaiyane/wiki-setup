import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'Engineering Wiki',
  tagline: 'All my apps, one place to read them all',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  url: 'https://supersaiyane.github.io',
  baseUrl: '/wiki-setup/',

  organizationName: 'supersaiyane',
  projectName: 'wiki-setup',

  onBrokenLinks: 'throw',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          editUrl: 'https://github.com/supersaiyane/wiki-setup/tree/main/',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  plugins: [
    [
      '@docusaurus/plugin-pwa',
      {
        debug: false,
        offlineModeActivationStrategies: ['appInstalled', 'standalone', 'queryString'],
        pwaHead: [
          {tagName: 'link', rel: 'manifest', href: '/wiki-setup/manifest.json'},
          {tagName: 'meta', name: 'theme-color', content: '#6366f1'},
          {tagName: 'meta', name: 'apple-mobile-web-app-capable', content: 'yes'},
          {tagName: 'meta', name: 'apple-mobile-web-app-status-bar-style', content: 'black-translucent'},
          {tagName: 'link', rel: 'apple-touch-icon', href: '/wiki-setup/img/icon-512.svg'},
        ],
      },
    ],
  ],

  themeConfig: {
    image: 'img/docusaurus-social-card.jpg',
    colorMode: {
      defaultMode: 'dark',
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'Engineering Wiki',
      logo: {
        alt: 'Wiki Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'wikiSidebar',
          position: 'left',
          label: 'Apps',
        },
        {
          href: 'https://www.linkedin.com/in/gurpreettsengh/',
          label: 'LinkedIn',
          position: 'right',
        },
        {
          href: 'https://medium.com/@gurpreet.singh_89',
          label: 'Medium',
          position: 'right',
        },
        {
          href: 'https://supersaiyane.github.io/gurpreetsingh/',
          label: 'Portfolio',
          position: 'right',
        },
        {
          href: 'https://github.com/supersaiyane',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Explore',
          items: [
            {
              label: 'All Wikis',
              to: '/docs/sample-app/',
            },
            {
              label: 'Vault',
              to: '/docs/sample-app/',
            },
          ],
        },
        {
          title: 'Connect',
          items: [
            {
              label: 'LinkedIn',
              href: 'https://www.linkedin.com/in/gurpreettsengh/',
            },
            {
              label: 'Medium',
              href: 'https://medium.com/@gurpreet.singh_89',
            },
            {
              label: 'Portfolio',
              href: 'https://supersaiyane.github.io/gurpreetsingh/',
            },
          ],
        },
        {
          title: 'Source',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/supersaiyane',
            },
            {
              label: 'Wiki Repo',
              href: 'https://github.com/supersaiyane/wiki-setup',
            },
          ],
        },
      ],
      copyright: `Copyright ${new Date().getFullYear()} Gurpreet Singh. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: ['bash', 'json', 'yaml', 'python', 'java', 'go', 'rust'],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
