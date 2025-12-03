const express = require('express')
const client = require('prom-client')
const app = express()
client.collectDefaultMetrics()
const histogram = new client.Histogram({ name: 'http_request_duration_seconds', help: 'duration', labelNames: ['route', 'method'], buckets: [0.05,0.1,0.2,0.5,1,2] })
const errors = new client.Counter({ name: 'http_requests_errors_total', help: 'errors' })
app.get('/health', (req, res) => { res.status(200).send('ok') })
app.get('/api', async (req, res) => {
  const end = histogram.startTimer({ route: '/api', method: 'GET' })
  try {
    res.json({ status: 'ok' })
  } catch (e) {
    errors.inc()
    res.status(500).json({ error: 'error' })
  } finally {
    end()
  }
})
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType)
  res.end(await client.register.metrics())
})
const port = process.env.PORT || 3000
if (require.main === module) { app.listen(port) }
module.exports = app
