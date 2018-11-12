const fs  = require('fs')
const yml = require('js-yaml')
const log = require('fancy-log')
const err = log.error
const request = require('request')

const nightliesFile = 'source/_data/nightlies.yml'
const bucketUrl = 'https://status-im.ams3.digitaloceanspaces.com'
const latestUrl = `${bucketUrl}/latest.json`

const nightlies = () => {
  return new Promise((resolve, reject) => {
    request(latestUrl, {json: true},
      (err, res) => {
        if (err) { throw err }
        if (res.statusCode != 200) {
          log(`URL: ${res.request.href}`)
          err(`Error: ${res.statusCode} ${res.statusMessage} - ${res.explanation}`)
          log('Unable to download latest nightlies, using default.')
          resolve()
        }
        yamlText = yml.safeDump(res.body, {lineWidth: 200})
        fs.writeFileSync(nightliesFile, yamlText)
        log(`Saved to: ${nightliesFile}`)
        resolve()
      }
    )
  })
}

module.exports = nightlies
