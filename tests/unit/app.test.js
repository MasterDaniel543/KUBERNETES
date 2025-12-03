const request = require('supertest')
const app = require('../../app/index')
test('health endpoint returns 200', async () => {
  const res = await request(app).get('/health')
  expect(res.statusCode).toBe(200)
})
