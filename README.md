## Status Technikon

To run the site locally, follow these instructions;

```bash
git clone https://github.com/status-im/docs.status.im.git
cd docs.status.im
git checkout NewSite
cd website/
npm install
npm run start
```

This site is built with Docusaurus](), go there to learn more.

All you really need to do is add an MD file in `/docs` and then reference it correctly in `website/sidebars.json` in the sidebar of your choice. There are some subtleties with versioning and translations which will be documented here at a later stage.