/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

// See https://docusaurus.io/docs/site-config.html for all the possible
// site configuration options.

/* List of projects/orgs using your project for the users page */
const users = [
  {
    caption: 'Cryptostrikers',
    image: '/img/shield-logo.svg',
    infoLink: 'https://www.cryptostrikers.com/',
    pinned: true,
  },
];

const siteConfig = {
  title: 'Status Technikon' /* title for your website */,
  tagline: 'Decentralised technologies at your fingertips',
  url: 'https://your-docusaurus-test-site.com' /* your website url */,
  baseUrl: '/' /* base url for your project */,
  // For github.io type URLs, you would set the url and baseUrl like:
  //   url: 'https://facebook.github.io',
  //   baseUrl: '/test-site/',

  // Used for publishing and more
  projectName: 'status-docs',
  organizationName: 'status-im',
  // For top-level user or org sites, the organization is still the same.
  // e.g., for the https://JoelMarcey.github.io site, it would be set like...
  //   organizationName: 'JoelMarcey'

  // For no header links in the top nav bar -> headerLinks: [],
  headerLinks: [
    {doc: 'introduction', label: 'Docs'},
    {href: 'https://ideas.status.im', label: 'Ideas'},
    {doc: 'testing', label: 'Testing'},
    {doc: 'intro_whisper', label: 'Whisper'},
    {doc: 'userguide', label: 'User Guide'},
    {page: 'help', label: 'Help'},
    {blog: true, label: 'Blog'},
    {languages: true},
    {search: true},
  ],

  algolia: {
    apiKey: 'my-api-key',
    indexName: 'my-index-name',
    algoliaOptions: {} // Optional, if provided by Algolia
  },

  // If you have users set above, you add it here:
  users,

  /* path to images for header/footer */
  headerIcon: 'img/logo_white.png',
  footerIcon: 'img/logo_white.png',
  favicon: 'img/favicon.png',

  /* colors for website */
  colors: {
    primaryColor: '#4A5AB5',
    secondaryColor: '#6CC1F6',
  },

  /* custom fonts for website */
  fonts: {
    myFont: [
      "PostGrotesk-Book",
      "Segoe UI",
      "Helvetica",
      "Arial",
      "Serif"
    ],
    myOtherFont: [
      "-apple-system",
      "BlinkMacSystemFont",
      "system-ui"
    ]
  },

  // This copyright info is used in /core/Footer.js and blog rss/atom feeds.
  copyright:
    'Copyright © ' +
    new Date().getFullYear() +
    ' Status.im',

  highlight: {
    // Highlight.js theme to use for syntax highlighting in code blocks
    theme: 'default',
  },

  // Add custom scripts here that would be placed in <script> tags
  scripts: ['https://buttons.github.io/buttons.js'],

  /* On page navigation for the current documentation page */
  onPageNav: 'separate',

  /* Open Graph and Twitter card images */
  ogImage: 'img/og_logo.png',
  twitterImage: 'img/og_logo.png',

  // You may provide arbitrary config keys to be used as needed by your
  // template. For example, if you need your repo's URL...
  //   repoUrl: 'https://github.com/facebook/test-site',
};

module.exports = siteConfig;
