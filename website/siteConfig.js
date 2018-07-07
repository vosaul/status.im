/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
const users = [
  {
    caption: 'Cryptostrikers',
    image: '/img/shield-logo.svg',
    infoLink: 'https://www.cryptostrikers.com/',
    pinned: true,
  },
];

const siteConfig = {
  title: 'Status Technikon',
  tagline: 'Decentralised technologies at your fingertips',
  url: 'https://status.im',
  baseUrl: '/',
  projectName: 'docs.status.im',
  organizationName: 'status-im',
  users,
  editUrl: 'https://github.com/status-im/docs.status.im/edit/develop/docs/',
  headerLinks: [
    {doc: 'introduction', label: 'Docs'},
    {href: 'https://ideas.status.im', label: 'Ideas'},
    {doc: 'testing', label: 'Testing'},
    {page: 'help', label: 'Help'},
    {blog: true, label: 'Blog'},
    {languages: false}
  ],
  headerIcon: 'img/logo_white.png',
  footerIcon: 'img/logo_white.png',
  favicon: 'img/favicon.png',
  colors: {
    primaryColor: '#4A5AB5',
    secondaryColor: '#6CC1F6',
  },
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
  copyright:
    'Copyright © ' +
    new Date().getFullYear() +
    ' Status.im',
  highlight: {
    theme: 'atom-one-dark',
  },
  scripts: ['https://buttons.github.io/buttons.js'],
  onPageNav: 'separate',
  ogImage: 'img/og_logo.png',
  twitterImage: 'img/og_logo.png',
  scrollToTop: true,
  scrollToTopOptions: {
    zIndex: 100,
  },
  repoUrl: 'https://github.com/status-im/status-react',
};

module.exports = siteConfig;
